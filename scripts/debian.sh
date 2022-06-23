#! /bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install stow neovim neofetch zsh -y

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ~/.zshrc
cd ~/.dotfiles
stow zsh


