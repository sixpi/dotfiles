autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info() {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed() {
  echo "$(git cherry @{upstream} | wc -l)"
}

need_push() {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}$(unpushed) unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
      echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  else
      echo ""
  fi
}

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo() {
  if (( $+commands[todo.sh] ))
  then
    echo "%{$fg_bold[yellow]%}$(todo.sh)%{$reset_color%} "
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

virtenv() {
  if [ -n "$VIRTUAL_ENV" ]
  then
    echo "(env: %{${fg[green]}%}`basename \"$VIRTUAL_ENV\"`%{${fg_bold[white]}%})"
  else
    echo ""
  fi
}

export PROMPT=$'\n$(rb_prompt) in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="$(virtenv) %{$fg_bold[cyan]%}$(todo)%{$reset_color%}"
  export RPROMPT2="$(virtenv) %{$fg_bold[cyan]%}$(todo)%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
