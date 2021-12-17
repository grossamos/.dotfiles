# .dotfiles

## Description
All Dotfiles, that I currently use to power my configs. This repo aims to improve sharing of it and usage across multiple systems.

[ultra rice](./.github/images/screenshot.png)

## Dependencies
- zsh (oh-my-zsh)
- gnu stow
- kitty
- sway (swaybar, sway-lock, etc.)
- waybar

## Setup
### Zsh
- install zsh and ohmyzsh (``sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"``)
- install autocomplete: ``git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions``
- delete default .zshrc and swap it out for my one: `stow zsh`
- set zsh as your default shell
### Kitty
- stow configs: `stow kitty`
- optionally stow ranger `stow ranger`
### Sway
- configure kitty as explained above
- install sway, rofi, waybar
- stow cofigs: `stow rofi && stow sway && stow waybar`
- clone `https://github.com/moverest/sway-interactive-screenshot` to `~/Documents/shell` 
- launch into sway

