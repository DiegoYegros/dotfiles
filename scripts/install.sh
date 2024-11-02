#!/bin/bash

snap_deps=(
    "go"
    "alacritty"
    "nvim"
)

snap_deps_extra=(
    "postman"
    "obsidian"
    "dbeaver-ce"
)

apt_deps=(
    "openjdk-21-jdk-headless"
    "maven"
    "npm"
    "xinput"
    "feh"
    "picom"
    "network-manager-gnome"
    "xss-lock"
    "maim"
    "xdotool"
    "i3blocks"
    "brightnessctl"
    "acpi"
    "curl"
    "arandr"
    "pavucontrol"
    "pulseaudio"
    "polybar"
    "automake"
    "cargo"
    "suckless-tools"
    "ripgrep"
    "cmake"
    "btop"
    "dex"
    "dunst"
    "fzf"
    "git"
    "i3lock"
    "zsh"
    "zathura"
    "xsel"
    "xclip"
    "tree"
    "tmux"
    "rofi"
    "net-tools"
)

apt_deps_extra=(
    "wine"
    "gnome-screenshot"
    "calibre"
    "rgrep"
    "dkms"
    "ghex"
    "vlc"
    "telnet"
    "sshpass"
    "screenfetch"
    "redis-server"
    "redis-tools"
    "openvpn"
)

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --full    Install all dependencies including extra packages"
    echo "  --help    Show this help message"
    echo ""
    echo "Without any options, only basic dependencies will be installed."
}

install() {
    local install_full=$1

    log_file="installation_script_log-$(date +"%Y%m%d_%H%M%S").txt"
    touch "$log_file"
    echo "Starting installation at $(date)" >"$log_file"
    echo "=============================================" >>"$log_file"

    for dep in "${apt_deps[@]}"; do
        echo "Installing apt package [$dep]..."
        sudo apt-get install -y "$dep" >>"$log_file" 2>&1
        if [ $? -eq 0 ]; then
            echo "Installed $dep successfully."
        else
            echo "Failed to install $dep. Check $log_file for details."
        fi
    done

    if [ "$install_full" = true ]; then
        echo "Installing extra apt packages..."
        for dep in "${apt_deps_extra[@]}"; do
            echo "Installing extra apt package [$dep]..."
            sudo apt-get install -y "$dep" >>"$log_file" 2>&1
            if [ $? -eq 0 ]; then
                echo "Installed $dep successfully."
            else
                echo "Failed to install $dep. Check $log_file for details."
            fi
        done
    fi

    for dep in "${snap_deps[@]}"; do
        echo "Installing snap package [$dep]..."
        sudo snap install "$dep" --classic >>"$log_file" 2>&1
        if [ $? -eq 0 ]; then
            echo "Installed $dep successfully."
        else
            echo "Failed to install $dep. Check $log_file for details."
        fi
    done

    if [ "$install_full" = true ]; then
        echo "Installing extra snap packages..."
        for dep in "${snap_deps_extra[@]}"; do
            echo "Installing extra snap package [$dep]..."
            sudo snap install "$dep" --classic >>"$log_file" 2>&1
            if [ $? -eq 0 ]; then
                echo "Installed $dep successfully."
            else
                echo "Failed to install $dep. Check $log_file for details."
            fi
        done
    fi

    script_dir=$(dirname "$(realpath "$0")")
    base_dir=$(realpath "$script_dir/..")

    echo "Creating symbolic links for dotfiles..."
    declare -A dotfiles=(
        ["alacritty"]=".config/alacritty"
        ["i3"]=".config/i3"
        ["i3blocks"]=".config/i3blocks"
        ["nvim"]=".config/nvim"
        ["polybar"]=".config/polybar"
        ["rofi"]=".config/rofi"
        ["scripts"]=".config/scripts"
        ["tmux"]=".config/tmux"
        ["bash_aliases.sh"]=".bash_aliases.sh"
        ["bash_functions.sh"]=".bash_functions.sh"
        ["bash_variables.sh"]=".bash_variables.sh"
        ["zshrc"]=".zshrc"
        ["bashrc"]=".bashrc"
    )

    # Backup and remove original .bashrc if it exists
    if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
        echo "Backing up original .bashrc..."
        mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
        echo "✓ Original .bashrc backed up to .bashrc.backup"
    fi

    for src in "${!dotfiles[@]}"; do
        dest="${dotfiles[$src]}"
        src_path="$base_dir/$src"
        dest_path="$HOME/$dest"
        mkdir -p "$(dirname "$dest_path")"
        if [ ! -L "$dest_path" ]; then
            ln -s "$src_path" "$dest_path"
            echo "Linked $src to $dest_path"
        else
            echo "Symbolic link for $dest_path already exists"
        fi
    done

    echo "Symbolic links created successfully."
    echo "Installation completed."
    echo "=============================================" >>"$log_file"
    echo "Installation completed at $(date)" >>"$log_file"
}

configure(){

    # Configure brightnessctl
    echo "Configuring system settings..."
    if sudo chmod +s $(which brightnessctl); then
        echo "✓ Configured brightnessctl permissions"
    else
        echo "✗ Failed to configure brightnessctl permissions"
    fi
 
    # Set zsh as default shell
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo "Setting ZSH as default shell..."
        if chsh -s $(which zsh); then
            echo "✓ ZSH set as default shell"
        else
            echo "✗ Failed to set ZSH as default shell"
        fi
    else
        echo "✓ ZSH is already the default shell"
    fi

    # TMUX TPM installation
    echo "Cloning tmux-plugins/tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo "✓ Cloned tmux-plugins/tpm successfully!"

    # Source tmux configuration
    tmux source-file ~/.config/tmux/tmux.conf || true

    # Install TPM plugins
    echo "Installing TPM plugins..."
    ~/.config/tmux/plugins/tpm/bin/install_plugins
    ~/.config/tmux/plugins/tpm/bin/update_plugins all
    
    # Clean up any existing temporary sessions
    tmux kill-session -t temp_session 2>/dev/null || true
    
    # Create a temporary session and install plugins
    if ! tmux has-session -t temp_session 2>/dev/null; then
        tmux new-session -d -s temp_session
        sleep 2
        tmux send-keys -t temp_session:0 "~/.config/tmux/plugins/tpm/bin/install_plugins" Enter
        sleep 5
        tmux kill-session -t temp_session
        echo "✓ TPM plugins installed successfully!"
    fi

    # Install Nerd Fonts
    echo "Installing Nerd Fonts..."
    script_dir=$(dirname "$(realpath "$0")")
    f [ -f "$script_dir/install-nerd-fonts.sh" ]; then
        bash "$script_dir/install-nerd-fonts.sh"
        if [ $? -eq 0 ]; then
            echo "✓ Nerd Fonts installed successfully"
        else
            echo "✗ Failed to install Nerd Fonts"
        fi
    else
        echo "✗ Could not find install-nerd-fonts.sh script"
    fi
}

main() {
    install_full=false
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                install_full=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    install "$install_full"
    configure
}

main "$@"
