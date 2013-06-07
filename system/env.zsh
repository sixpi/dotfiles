HAVE_EMACS=$(command -v emacs)
HAVE_VIM=$(command -v vim)

EMACS_VERSION=$(emacs --version)

# set editor, prefer emacs if we have it
EDITOR=vi
test -n "$HAVE_VIM" && EDITOR=vim
test -n "$HAVE_EMACS" && EDITOR="emacsclient -t -a 'emacs -nw -q'"
export EDITOR
