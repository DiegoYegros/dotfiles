# fix your wallpaper (stupid bug)
alias wallpaper='/home/daya/.config/scripts/fehbg.sh'

# CONFIG SHORTCUTS
alias i3config='nvim $HOME/.config/i3/config'
alias nvimconfig='nvim $HOME/.config/nvim/'
alias alacrittyconfig='nvim $HOME/.config/alacritty/alacritty.toml'
alias tmuxconfig='nvim $HOME/.config/tmux/tmux.conf'

# GIT
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias grs='git restore --staged'
alias gr='git restore'

# NEOFETCH IS ARCHIVED!

alias neofetch='screenfetch'
alias home='cd "/mnt/c/Users/Diego Yegros/"'
# MAVEN
alias mvnci='mvn clean install'
alias mvncid='mvn clean install -DskipTests'
alias mvntree='mvn dependency:tree'

# BASH
alias bashaliases='nvim ~/.bash_aliases'
alias bashfunctions='nvim ~/.bash_functions'
alias sourcebash='source ~/.bashrc'
alias sourcezsh='source ~/.zshrc'

# NVIM
alias vim='nvim'
alias vi='nvim'

# EMULATE WINDOWS BEHAVIOUR
alias cls='clear'

# SYSTEM SERVICES
alias sstart='systemctl start'
alias sstop='systemctl stop'
alias sstatus='systemctl status'
alias srestart='systemctl restart'
alias services='systemctl list-units --type=service'

# NICE SHORTCUTS
alias duh='du -h --max-depth=1'
alias dfh='df -h'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias copy='xclip -selection clipboard'
alias ll='ls -alFh'
alias ls='ls -lahF --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias mkdir='mkdir -v'
alias cp='cp -v'
alias mv='mv -v'
alias claer='clear'
alias pdf='zathura'
# DOCKER
alias dps='docker ps'
alias dpsa='docker ps -a'

# YT-DLP
alias yt='yt-dlp -P '~/Videos/' '

# UPDATE SYSTEM
alias update='$HOME/.config/scripts/update.sh'
