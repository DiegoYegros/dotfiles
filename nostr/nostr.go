package main

import (
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"syscall"
	"time"

	"github.com/btcsuite/btcd/btcutil/bech32"
	"github.com/nbd-wtf/go-nostr"
	"golang.org/x/crypto/argon2"
	"golang.org/x/term"
)

type Config struct {
	Relays    []string `json:"relays"`
	PrivKey   string   `json:"encrypted_private_key"`
	Salt      string   `json:"salt"`
	PublicKey string   `json:"public_key"`
}

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	command := os.Args[1]

	switch {
	case command == "--setup":
		runSetup()
	case command == "--help":
		printUsage()
	default:
		// Treat any other input as a message to publish
		runPublish(command)
	}
}

func printUsage() {
	fmt.Println("Usage:")
	fmt.Println("  nostr --setup                  # Setup your Nostr private key")
	fmt.Println("  nostr --help                   # Show this help message")
	fmt.Println("  nostr \"your message here\"      # Publish a note to Nostr")
}

func getConfigPath() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	return filepath.Join(homeDir, ".config", "nostr", "config.json")
}

func readPassword(prompt string) (string, error) {
	fmt.Print(prompt)
	bytePassword, err := term.ReadPassword(int(syscall.Stdin))
	fmt.Println()
	if err != nil {
		return "", err
	}
	return string(bytePassword), nil
}

func deriveKey(password string, salt []byte) ([]byte, error) {
	return argon2.IDKey([]byte(password), salt, 1, 64*1024, 4, 32), nil
}

func encrypt(data []byte, password string, salt []byte) (string, error) {
	key, err := deriveKey(password, salt)
	if err != nil {
		return "", err
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return "", err
	}

	ciphertext := gcm.Seal(nonce, nonce, data, nil)
	return base64.StdEncoding.EncodeToString(ciphertext), nil
}

func decrypt(encryptedData string, password string, salt []byte) (string, error) {
	key, err := deriveKey(password, salt)
	if err != nil {
		return "", err
	}

	ciphertext, err := base64.StdEncoding.DecodeString(encryptedData)
	if err != nil {
		return "", err
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}

	nonceSize := gcm.NonceSize()
	if len(ciphertext) < nonceSize {
		return "", fmt.Errorf("ciphertext too short")
	}

	nonce, ciphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return "", err
	}

	return string(plaintext), nil
}

func nsecToHex(nsec string) (string, error) {
	hrp, data, err := bech32.Decode(nsec)
	if err != nil {
		return "", fmt.Errorf("invalid nsec format: %v", err)
	}

	// Verify the human-readable prefix is "nsec"
	if hrp != "nsec" {
		return "", fmt.Errorf("invalid prefix: expected nsec, got %s", hrp)
	}

	// Convert from 5-bit to 8-bit
	converted, err := bech32.ConvertBits(data, 5, 8, false)
	if err != nil {
		return "", fmt.Errorf("failed to convert bits: %v", err)
	}

	// Convert the byte slice to hex string
	return hex.EncodeToString(converted), nil
}

func runSetup() {
	// Create config directory if it doesn't exist
	configPath := getConfigPath()
	os.MkdirAll(filepath.Dir(configPath), 0700)

	// Get private key from user
	fmt.Print("Enter your private key (nsec format): ")
	var nsec string
	fmt.Scanln(&nsec)

	// Convert nsec to hex format
	sk, err := nsecToHex(nsec)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	// Validate private key format and derive public key
	pk, err := nostr.GetPublicKey(sk)
	if err != nil {
		fmt.Println("Error: Invalid private key")
		return
	}

	// Get password for encryption
	password, err := readPassword("Enter password to encrypt private key: ")
	if err != nil {
		fmt.Println("Error reading password:", err)
		return
	}

	// Confirm password
	confirmPassword, err := readPassword("Confirm password: ")
	if err != nil {
		fmt.Println("Error reading password:", err)
		return
	}

	if password != confirmPassword {
		fmt.Println("Error: Passwords do not match")
		return
	}

	// Generate random salt
	salt := make([]byte, 16)
	if _, err := io.ReadFull(rand.Reader, salt); err != nil {
		fmt.Println("Error generating salt:", err)
		return
	}

	// Encrypt private key
	encryptedKey, err := encrypt([]byte(sk), password, salt)
	if err != nil {
		fmt.Println("Error encrypting private key:", err)
		return
	}

	// Check if config file exists and load it
	var config Config

	// Default relays if we need to create a new config
	defaultRelays := []string{
		"wss://relay.damus.io",
		"wss://relay.primal.net",
		"wss://nos.lol",
	}

	// Try to read existing config
	if configData, err := os.ReadFile(configPath); err == nil {
		// Config exists, parse it
		if err := json.Unmarshal(configData, &config); err != nil {
			fmt.Println("Error parsing existing config:", err)
			return
		}
	} else {
		// Config doesn't exist, create directory and use default relays
		os.MkdirAll(filepath.Dir(configPath), 0700)
		config.Relays = defaultRelays
	}

	// Update only the key-related fields
	config.PrivKey = encryptedKey
	config.Salt = hex.EncodeToString(salt)
	config.PublicKey = pk

	// Save config
	configJson, _ := json.MarshalIndent(config, "", "  ")
	err = os.WriteFile(configPath, configJson, 0600)
	if err != nil {
		fmt.Println("Error saving config:", err)
		return
	}

	fmt.Println("Setup complete! Your public key is:", pk)
}

func runPublish(message string) {
	// Read config
	configPath := getConfigPath()
	configData, err := os.ReadFile(configPath)
	if err != nil {
		fmt.Println("Error reading config:", err)
		return
	}

	var config Config
	err = json.Unmarshal(configData, &config)
	if err != nil {
		fmt.Println("Error parsing config:", err)
		return
	}

	// Get password to decrypt private key
	password, err := readPassword("Enter password to decrypt private key: ")
	if err != nil {
		fmt.Println("Error reading password:", err)
		return
	}

	// Decrypt private key
	salt, err := hex.DecodeString(config.Salt)
	if err != nil {
		fmt.Println("Error decoding salt:", err)
		return
	}

	sk, err := decrypt(config.PrivKey, password, salt)
	if err != nil {
		fmt.Println("Error decrypting private key:", err)
		return
	}

	// Create event
	ev := nostr.Event{
		PubKey:    config.PublicKey,
		CreatedAt: nostr.Now(),
		Kind:      1,
		Tags:      nil,
		Content:   message,
	}

	// Sign event
	ev.Sign(sk)

	// Create context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Publish to all relays
	for _, url := range config.Relays {
		relay, err := nostr.RelayConnect(ctx, url)
		if err != nil {
			fmt.Printf("Failed to connect to %s: %v\n", url, err)
			continue
		}

		err = relay.Publish(ctx, ev)
		if err != nil {
			fmt.Printf("Failed to publish to %s: %v\n", url, err)
		} else {
			fmt.Printf("Published to %s\n", url)
		}
		relay.Close()
	}
}
