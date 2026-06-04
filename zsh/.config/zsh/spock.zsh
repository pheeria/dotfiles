# Inspired by https://github.com/tobyjamesthomas/pi
# and by shashankmehta (https://github.com/shashankmehta)
function get_pwd() {
  local dir=$PWD
  while [[ $dir != / && ! -e $dir/.git ]]; do
    dir=$dir:h
  done
  if [[ $dir = / ]]; then
    print -r -- '%~'
  else
    # ${${dir:h}%/} drops a trailing slash so a repo directly under / keeps no leading slash
    print -r -- "${PWD#${${dir:h}%/}/}"
  fi
}

return_status="%(?:🖖:🤨)"
prompt_suffix="%{$fg[cyan]%}❯%{$reset_color%} "

if [[ -n $CODESPACES ]]; then
  remote_indicator="%{$fg[red]%}[cs]%{$reset_color%} "
else
  remote_indicator=""
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT=' ${remote_indicator}${return_status} %{$fg[cyan]%}$(get_pwd)%{$reset_color%} $(git_prompt_info)${prompt_suffix}'
