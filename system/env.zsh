HAVE_EMACS=$(command -v emacs)
HAVE_VIM=$(command -v vim)

EMACS_VERSION=$(emacs --version)

# set editor, prefer emacs if we have it
EDITOR=vi
test -n "$HAVE_VIM" && EDITOR=vim
if [ -n "$HAVE_EMACS" ]; then
    EDITOR="emacsclient -t"
    ALTERNATE_EDITOR="emacs -nw"
    export ALTERNATE_EDITOR
fi
export EDITOR

if [[ -e /lib/terminfo/x/xterm-256color ]]; then
    export TERM=xterm-256color
fi

if [[ -e /usr/share/terminfo/x/xterm-256color ]]; then
    export TERM=xterm-256color
fi
