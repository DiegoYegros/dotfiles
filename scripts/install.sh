#!/bin/bash

snap_deps=(
	"go"
	"alacritty"
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
	"wine"
	"xdotool"
	"gnome-screenshot"
	"i3blocks"
	"brightnessctl"
	"acpi"
	"arandr"
	"pavucontrol"
	"pulseaudio"
	"polybar"
	"automake"
	"calibre"
	"cargo"
	"suckless-tools"
	"rgrep"
	"ripgrep"
	"cmake"
	"btop"
	"dex"
	"neovim"
	"dkms"
	"dunst"
	"fzf"
	"ghex"
	"git"
	"i3lock"
	"zsh"
	"zathura"
	"xsel"
	"xclip"
	"vlc"
	"tree"
	"tmux"
	"telnet"
	"sshpass"
	"screenfetch"
	"rofi"
	"redis-server"
	"redis-tools"
	"openvpn"
	"net-tools"
)

install() {
	# Create log file
	log_file="i3_install_log_$(date +"%Y%m%d_%H%M%S").txt"
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

	for dep in "${snap_deps[@]}"; do
		echo "Installing snap package [$dep]..."
		sudo snap install "$dep" --classic >>"$log_file" 2>&1
		if [ $? -eq 0 ]; then
			echo "Installed $dep successfully."
		else
			echo "Failed to install $dep. Check $log_file for details."
		fi
	done

	script_dir=$(dirname "$(realpath "$0")")
	base_dir=$(realpath "$script_dir/..")

	echo "Creating symbolic links for dotfiles..."

	declare -A dotfiles=(
		["alacritty"]=".alacritty"
		["i3"]=".i3"
		["i3blocks"]=".i3blocks"
		["nvim"]=".config/nvim"
		["polybar"]=".config/polybar"
		["rofi"]=".config/rofi"
		["scripts"]=".scripts"
		["tmux"]=".tmux.conf"
	)

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
	sudo chmod +s $(which brightnessctl)
}

main() {
	install
	configure
}

main "$@"

