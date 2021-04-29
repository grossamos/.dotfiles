# .dotfiles

## Description
All Dotfiles, that I currently use to power my configs. This repo aims to improve sharing of it and usage across multiple systems.

## Dependencies
- zsh (oh-my-zsh)
- gnu stow
- node
- tmux
- vim/nvim

## Setup
Make sure all the dependancies are installed.

For zsh:
- if you user is not called ``amos`` rename the ``USR_DIR`` in ``zsh/.zshrc``
- then install oh-my-zsh: ``sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"``
- if present, remove any preexisting .zshrc or ohmyzsh files
- create the links for my parrot theme and zshrc: ``stow oh-my-zsh zsh``
- install oh-my-zsh autosuggestions: ``git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions``
- now relaunch zsh and my config should be available to you

For vim:
- create symlinks for all vim configs: ``stow vim``
- if you want to use neovim create a symlink for .vimrc: ``ln -s ~/.vimrc ~/.config/nvim/init.vim`` and install plug for neovim: ``sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'``
- install node for autocompletion
- if nessicary run ``:PlugInstall``
- for coc you might want to add vala, etc. cofigs:
```
{
    "languageserver": {
        "vala": {
            "command": "vala-language-server",
            "filetypes": ["vala", "genie"]
        }
    }
}
```
- for this vala autocompletion you also need to install the [vala-language-server](https://github.com/Prince781/vala-language-server)

For tmux, picom and i3:
- nothing special here, just run ``stow tmux picom i3``

## Contents

### Vim
- plungin manager: plug
- theme: gruvbox
- autocomplete

### Zsh
- we are using oh my zsh as the main source for plugins
- remember to set zsh as the default shell
- for the terminal remember to set the terminal color theme to aci (ex. with gogh https://github.com/Mayccoll/Gogh)

