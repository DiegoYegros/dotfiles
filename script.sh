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
  log "Installing brightnessctl..." sudo apt install brightnessctl -y &>/dev/null
  log "Installing xbacklight..." sudo apt-get install xbacklight alsa-utils pulseaudio -y &>/dev/null
  log "Installing rofi..." sudo apt install rofi -y &>/dev/null
}

customize_system() {
  cd powerline-shell
  log "Building Powerline Shell installation..." python3 setup.py build &>/dev/null
  log "Installing Powerline Shell..." python3 setup.py install &>/dev/null
  log "Adding user to the video group..." sudo usermod -aG video $USER
  log "Copying dircolors to home directory..." cp $PWD/.dircolors $HOME
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
install_docker(){
 log "Removing previous docker-desktop if existed..." sudo apt remove docker-desktop -y
  rm -r $HOME/.docker/desktop &>/dev/null
  sudo rm /usr/local/bin/com.docker.cli &>/dev/null
  sudo apt purge docker-desktop &>/dev/null
  sudo apt-get install ca-certificates curl gnupg -y &>/dev/null
  sudo install -m 0755 -d /etc/apt/keyrings &>/dev/null
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &>/dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg &>/dev/null
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \ &>/dev/null
  sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null
  log "Installing docker... " sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>/dev/null
}

main() {
  install_packages
  customize_system
  copy_dotfiles
  install_docker
}

main
