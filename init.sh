#! /bin/bash

# install zsh, themes and plugins
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc.pre-oh-my-zsh ~/.zshrc
cp ./oh-my-zsh/parrot.zsh-theme ~/.oh-my-zsh/themes/
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# create symlinks for dotfiles
stow vim
stow zsh
stow tmux
