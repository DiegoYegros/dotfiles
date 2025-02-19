#!/bin/bash

snap_deps=(
    "go"
    "alacritty"
)

snap_deps_extra=(
    "postman"
    "obsidian"
    "dbeaver-ce"
)

apt_deps=(
    "openjdk-21-jdk-headless"
    "maven"
    "neovim"
    "npm"
    "unzip"
    "gcc"
    "yt-dlp"
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

dnf_deps=(
    "java-21-openjdk-devel"
    "maven"
    "neovim"
    "nodejs"
    "yt-dlp"
    "xorg-xinput"
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
    "rust"
    "dmenu"
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

dnf_deps_extra=(
    "wine"
    "gnome-screenshot"
    "calibre"
    "dkms"
    "ghex"
    "vlc"
    "telnet"
    "sshpass"
    "screenfetch"
    "redis"
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

install_ubuntu() {
    local install_full=$1
    log_file="installation_script_log-$(date +"%Y%m%d_%H%M%S").txt"
    echo "Starting Ubuntu installation at $(date)" >"$log_file"

    for dep in "${apt_deps[@]}"; do
        echo "Installing apt package [$dep]..."
        sudo apt-get install -y "$dep" >>"$log_file" 2>&1
        [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
    done

    if [ "$install_full" = true ]; then
        for dep in "${apt_deps_extra[@]}"; do
            echo "Installing extra apt package [$dep]..."
            sudo apt-get install -y "$dep" >>"$log_file" 2>&1
            [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
        done
    fi

    install_snap_packages "$install_full"
    setup_common
}

install_fedora() {
    local install_full=$1
    log_file="installation_script_log-$(date +"%Y%m%d_%H%M%S").txt"
    echo "Starting Fedora installation at $(date)" >"$log_file"

    echo "Enabling RPM Fusion repositories..."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm >>"$log_file" 2>&1

    for dep in "${dnf_deps[@]}"; do
        echo "Installing dnf package [$dep]..."
        sudo dnf install -y "$dep" >>"$log_file" 2>&1
        [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
    done

    if [ "$install_full" = true ]; then
        for dep in "${dnf_deps_extra[@]}"; do
            echo "Installing extra dnf package [$dep]..."
            sudo dnf install -y "$dep" >>"$log_file" 2>&1
            [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
        done
    fi

    if ! command -v snap &>/dev/null; then
        echo "Installing snapd..."
        sudo dnf install -y snapd >>"$log_file" 2>&1
        sudo systemctl enable --now snapd.socket >>"$log_file" 2>&1
        sudo ln -s /var/lib/snapd/snap /snap >>"$log_file" 2>&1
    fi

    install_snap_packages "$install_full"
    setup_common
}

install_snap_packages() {
    local install_full=$1
    for dep in "${snap_deps[@]}"; do
        echo "Installing snap package [$dep]..."
        sudo snap install "$dep" --classic >>"$log_file" 2>&1
        [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
    done

    if [ "$install_full" = true ]; then
        for dep in "${snap_deps_extra[@]}"; do
            echo "Installing extra snap package [$dep]..."
            sudo snap install "$dep" --classic >>"$log_file" 2>&1
            [ $? -eq 0 ] && echo "Installed $dep successfully." || echo "Failed to install $dep"
        done
    fi
}

setup_common() {
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
        ["nostr"]=".config/nostr"
    )

    if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
        echo "Backing up original .bashrc..."
        mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
    fi

    for src in "${!dotfiles[@]}"; do
        dest="${dotfiles[$src]}"
        src_path="$base_dir/$src"
        dest_path="$HOME/$dest"
        mkdir -p "$(dirname "$dest_path")"
        [ ! -L "$dest_path" ] && ln -s "$src_path" "$dest_path"
    done
}

configure() {
    echo "Configuring system settings..."
    sudo chmod +s $(which brightnessctl) 2>/dev/null && echo "✓ Configured brightnessctl permissions"

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh) && echo "✓ ZSH set as default shell" || echo "✗ Failed to set ZSH"
    fi

    [ ! -d ~/.config/tmux/plugins/tpm ] &&
        git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

    script_dir=$(dirname "$(realpath "$0")")
    [ -f "$script_dir/install-nerd-fonts.sh" ] && bash "$script_dir/install-nerd-fonts.sh"

    nostr_dir="$HOME/.config/nostr"
    [ -d "$nostr_dir" ] && {
        cd "$nostr_dir"
        go get nostr-cli
        go build -o nostr && mkdir -p "$HOME/bin" && mv nostr "$HOME/bin"
    }
}

main() {
    local install_full=false
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full) install_full=true ;;
            --help) show_usage; exit 0 ;;
            *) echo "Unknown option: $1"; show_usage; exit 1 ;;
        esac
        shift
    done

    case $(get_distribution) in
        ubuntu) install_ubuntu "$install_full" ;;
        fedora) install_fedora "$install_full" ;;
        *) echo "Unsupported distribution"; exit 1 ;;
    esac

    configure
    echo "Installation completed. Log saved to $log_file"
}

get_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        lsb_release -i | cut -d: -f2 | sed 's/\t//g'
    fi
}

main "$@"
