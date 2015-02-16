pathmunge()
{
    if ! echo $PATH | /bin/grep -qE "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

pathmunge $ZSH/bin
pathmunge $HOME/bin

if [[ -d $HOME/anaconda/bin ]]
then
    pathmunge $HOME/anaconda/bin
fi

pathmunge ./bin

export PATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

unset pathmunge
