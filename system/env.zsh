HAVE_EMACS=$(command -v emacs)
HAVE_VIM=$(command -v vim)

# set editor, prefer emacs if we have it
EDITOR=vi
test -n "$HAVE_VIM" && EDITOR=vim
test -n "$HAVE_EMACS" && EDITOR=emacs
export EDITOR
