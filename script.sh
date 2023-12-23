#!/bin/bash

# Function for logging
log() {
  local msg="$1"; shift
  if [[ "${LOG_LEVEL}" == "info" || "${LOG_LEVEL}" == "quiet" ]]; then
    printf "[%s]: %s\\n" "$*" "$msg" >&2
  elif [[ "${LOG_LEVEL}" == "debug" ]]; then
    # Debug mode outputs even more detailed info
    echo "[DEBUG][${*}]: ${msg}"
  fi
}

# Initialize logger
LOG_LEVEL="quiet"

# Original script with added logging functionality
install_packages() {
  log "Installing PsUtil..." sudo apt install python3-psutil -y &>/dev/null
  log "Installing Font Awesome..." sudo apt install fonts-font-awesome -y &>/dev/null
  log "Installing Feh..." sudo apt-get install -y feh &>/dev/null
  log "Installing PyGObject for the battery monitor module..." sudo apt install python3-gi -y &>/dev/null
  log "Installing pygit2 for the git module..." sudo apt install python3-pip -y && pip3 install pygit2 &>/dev/null
  log "Installing Powerline Shell..." git clone https://github.com/b-ryan/powerline-shell &>/dev/null
}

customize_system() {
  cd powerline-shell
  log "Building Powerline Shell installation..." python3 setup.py build &>/dev/null
  log "Installing Powerline Shell..." python3 setup.py install &>/dev/null
  cd ..
}

copy_dotfiles() {
  local source_file="$PWD/.bashrc"
  local destination_dir="${HOME}"

  if [ -f "$source_file" ]; then
    cp -f "$source_file" "$destination_dir"
    log "Copied .bashrc and replaced existing file in the user's home directory."
  else
    cp "$source_file" "$destination_dir"
    log "Copied .bashrc to the user's home directory."
  fi
}

main() {
  install_packages
  customize_system
  copy_dotfiles
}

main
