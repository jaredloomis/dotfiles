# Add vim as default editor
export EDITOR=vim
export TERM=xterm

alias ls='ls --color=auto'

# Open commands, mimeopen is much better that xdg-open
alias open='mimeopen'
alias ']'='mimeopen'

# Don't need the banner
#[ ! "$UID" = "0" ] && archbey2

PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

export WINEPREFIX=$HOME/win32
export WINEARCH=win32

export PATSHOME=/usr/local/lib/ats2-postiats-0.1.8
