#!/bin/bash

deps=(
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
	"ripgrep"
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

	for dep in "${deps[@]}"; do
		echo "Installing $dep..."
		sudo apt-get install -y "$dep" >>"$log_file" 2>&1
		if [ $? -eq 0 ]; then
			echo "Installed $dep successfully."
		else
			echo "Failed to install $dep. Check $log_file for details."
		fi
	done

	echo "Installation completed."
	echo "=============================================" >>"$log_file"
	echo "Installation completed at $(date)" >>"$log_file"
}

main() {
	install
}

main "$@"
