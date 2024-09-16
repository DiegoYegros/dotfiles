#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

hide_cursor() {
	printf "\e[?25l"
}

show_cursor() {
	printf "\e[?25h"
}

trap show_cursor EXIT

spinner() {
	local pid=$1
	local delay=0.1
	local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
	printf "  "
	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		local temp=${spinstr#?}
		printf "\b\b%s" "${spinstr:0:1}"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
	done
	printf "\b\b "
}

print_color() {
	local color_name="$1"
	local message="$2"
	case "$color_name" in
	"RED") printf "${RED}%s${NC}\n" "$message" ;;
	"GREEN") printf "${GREEN}%s${NC}\n" "$message" ;;
	"YELLOW") printf "${YELLOW}%s${NC}\n" "$message" ;;
	"BLUE") printf "${BLUE}%s${NC}\n" "$message" ;;
	*) printf "%s\n" "$message" ;;
	esac
}

print_separator() {
	printf "%$(tput cols)s\n" | tr ' ' '-'
}

run_sudo_command() {
	print_color "BLUE" "Running: $1"
	hide_cursor
	(sudo "$1" >/dev/null 2>&1) &
	spinner $!
	wait $!
	show_cursor
	if [ $? -ne 0 ]; then
		print_color "RED" "Command failed: $1"
		return 1
	fi
	print_color "GREEN" "Done"
	print_separator
}

keep_sudo_alive() {
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &
}

update_packages() {
	run_sudo_command "apt update -y"
}

upgrade_packages() {
	hide_cursor
	upgrade_info=$(sudo apt full-upgrade -s 2>/dev/null)
	show_cursor
	packages_to_upgrade=$(echo "$upgrade_info" | grep "^Inst" | wc -l)

	if [ "$packages_to_upgrade" -gt 0 ]; then
		print_color "YELLOW" "Packages to upgrade: $packages_to_upgrade"
		print_color "YELLOW" "Do you want to proceed with the upgrade? (y/n)"
		show_cursor
		read -r response
		hide_cursor
		if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
			run_sudo_command "apt upgrade -y"
		else
			print_color "RED" "Upgrade cancelled."
			return 1
		fi
	else
		print_color "GREEN" "Your system is up to date. No upgrades needed."
	fi
}

cleanup() {
	run_sudo_command "apt autoremove -y"
	run_sudo_command "apt clean -y"
	run_sudo_command "apt autoclean -y"
}

main() {
	hide_cursor
	print_color "GREEN" "Starting system update process..."
	print_separator
	print_color "YELLOW" "Please enter your sudo password:"

	show_cursor
	if ! sudo -v; then
		print_color "RED" "Failed to obtain sudo privileges. Exiting."
		exit 1
	fi
	hide_cursor

	keep_sudo_alive

	if ! update_packages; then
		print_color "RED" "Failed to update package lists. Exiting."
		exit 1
	fi

	if ! upgrade_packages; then
		print_color "RED" "Package upgrade process failed or was cancelled. Exiting."
		exit 1
	fi

	if ! cleanup; then
		print_color "RED" "Cleanup process failed. Exiting."
		exit 1
	fi

	print_color "GREEN" "System update process completed successfully!"
	show_cursor
}

main
