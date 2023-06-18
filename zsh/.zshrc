export ZSH="/home/amos/.zsh"

export VISUAL=nvim;
export EDITOR=nvim;

[[ -r ~/.zsh/antigen.zsh ]] ||
    curl -L git.io/antigen > ~/.zsh/antigen.zsh
source ~/.zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-autosuggestions

antigen theme gentoo

antigen apply

alias ll='ls -lah'
if type "nvim" > /dev/null; then
  alias vim='nvim'
fi

# ls after calling cd
cd()
{
    builtin cd $@
    ls
}

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

