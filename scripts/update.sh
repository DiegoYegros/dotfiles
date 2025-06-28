#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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
    while kill -0 "$pid" 2>/dev/null; do
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
    local cmd="$1"
    print_color "BLUE" "Running: $cmd"
    hide_cursor
    eval "sudo $cmd" >/dev/null 2>&1 &
    local cmd_pid=$!
    spinner $cmd_pid
    wait $cmd_pid
    local exit_status=$?
    show_cursor
    if [ $exit_status -ne 0 ]; then
        print_color "RED" "Command failed: $cmd"
        return 1
    fi
    print_color "GREEN" "Done"
    print_separator
    return 0
}

keep_sudo_alive() {
    while true; do
        sudo -n true 2>/dev/null
        sleep 60
        kill -0 "$$" 2>/dev/null || exit
    done &
}

update_packages() {
    run_sudo_command "apt update"
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
        case "${response,,}" in
            y|yes)
                run_sudo_command "apt full-upgrade -y"
                ;;
            *)
                print_color "RED" "Upgrade cancelled."
                return 1
                ;;
        esac
    else
        print_color "GREEN" "Your system is up to date. No upgrades needed."
    fi
}

cleanup() {
    run_sudo_command "apt autoremove -y" && \
    run_sudo_command "apt clean" && \
    run_sudo_command "apt autoclean"
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
