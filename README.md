# .dotfiles

## Description
All Dotfiles, that I currently use to power my configs. This repo aims to improve sharing of it and usage across multiple systems.

## Dependencies
- zsh (oh-my-zsh)
- gnu stow
- node
- yarn
- tmux
- vim/nvim

## Setup
Make sure all the dependancies are installed.

For zsh:
- if you user is not called ``amos`` rename the ``USR_DIR`` in ``zsh/.zshrc``
- then install oh-my-zsh: ``sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"``
- if present, remove any preexisting .zshrc files
- create the links for my parrot theme and zshrc: ``stow oh-my-zsh zsh``
- install oh-my-zsh autosuggestions: ``git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions``
- now relaunch zsh and my config should be available to you
- for gnome-terminal you also might want to set the terminal color theme to aci (ex. with gogh https://github.com/Mayccoll/Gogh)

For vim:
- create symlinks for all vim configs: ``stow vim``
- to install plugins and the clangd server just open up a c file: ``vim DELETEME.c``. Wait for Plug to finish install, then reopen the file and run ``CocCommand clangd.install``
- if you want to use neovim create a symlink for .vimrc: ``ln -s ~/.vimrc ~/.config/nvim/init.vim`` and install plug for neovim: ``sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'``

for awesomewm:
- creaye symlinks: ``stow awesomewm``
- make sure you have rofi installed (or else your run prompt will not function)
- now reload awesomewm with ``ctrl+mod4+r``

- for the terminal remember to set the terminal color theme to aci (ex. with gogh https://github.com/Mayccoll/Gogh)

