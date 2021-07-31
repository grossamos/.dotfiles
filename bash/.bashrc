# .bashrc

#############################
#       Default stuff       #
#############################


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

#############################
#         Styling           #
#############################

export PS1="\[\033[01;92m\]\u" # User
PS1+="\[\033[01;96m\]@"
PS1+="\[\033[01;92m\]\H:" # Host
PS1+="\[\033[01;95m\]\w" # PWD
PS1+="\[\033[01;00m\]$ " # PWD



#############################
#         Aliases           #
#############################

# use ranger for navigation
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# some basics
alias ll='ls -la'
alias la='ls -a'

# ls after calling cd
cd()
{
    builtin cd $@
    ls
}

# Kernel development Aliases

alias make_modules='make -C ~/Linux/linux/ M=`pwd` modules'
