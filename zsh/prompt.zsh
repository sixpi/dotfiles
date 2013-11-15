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
  $git cherry -v @{upstream} 2>/dev/null
}

num_unpushed() {
  $git cherry -v @{upstream} 2>/dev/null | wc -l
}

need_push() {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}$(num_unpushed) unpushed%{$reset_color%} "
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
  echo "%{$fg_bold[cyan]%}%~%{$reset_color%}"
}

login_info() {
  echo "%{$fg_bold[cyan]%}%n%{$fg_bold[white]%}@%{$fg_bold[green]%}%m%{$reset_color%}"
}

virtenv() {
  if [ -n "$VIRTUAL_ENV" ]
  then
    echo "(venv: %{${fg[green]}%}`basename \"$VIRTUAL_ENV\"`%{${fg_bold[white]}%})"
  else
    echo ""
  fi
}

export PROMPT=$'\n$(login_info) in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="$(virtenv) $(rb_prompt)%{$fg_bold[cyan]%}%!!%{$reset_color%}"
}

precmd () {
  title "zsh" "%n@%m" "%55<...<%2c"
  set_prompt
}

preexec () {
  title "$1" "%n@%m" "%35<...<%2c"
}
