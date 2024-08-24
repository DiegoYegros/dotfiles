## Good to know
If you want to use the tmux theme and you're using WSL, you'll have to install a Nerd Font (JetBrainsMono Nerd Font, for instance) in your Windows Host and use it as the terminal font in order to get the glyphs working. Also remember to run the ./install-dependencies.sh and ./install-nerd-fonts.sh scripts.

![image](https://github.com/DiegoYegros/dotfiles/assets/64743423/6b2bf4e6-653f-4acd-877c-c5b1106a0c7c)

## TO DOs
1. Make the initial setup distro-agnostic. Currently you have to run install-dependencies.sh if you're on Ubuntu, or use configuration.nix on Nix OS. This should be transparent.
