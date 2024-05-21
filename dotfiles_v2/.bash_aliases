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

# MAVEN
alias mvnci='mvn clean install'
alias mvncid='mvn clean install -DskipTests'
alias mvntree='mvn dependency:tree'

# BASH 
alias bashaliases='nvim ~/.bash_aliases'
alias bashfunctions='nvim ~/.bash_functions'
alias sourcebash='source ~/.bashrc'

# NVIM 
alias vim='nvim'
alias vi='nvim'

# EMULATE WINDOWS BEHAVIOUR
alias cls='clear'

# SYSTEM SERVICES
alias sstart='systemctl start tomcat'
alias sstop='systemctl stop tomcat'
alias srestart='systemctl restart tomcat'
alias services='systemctl list-units --type=service'

# NICE SHORTCUTS
alias duh='du -h --max-depth=1'
alias dfh='df -h'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias copy='xclip -selection clipboard'

# DOCKER
alias dps='docker ps'
alias dpsa='docker ps -a'


# UPDATE SYSTEM 
alias update='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y'
