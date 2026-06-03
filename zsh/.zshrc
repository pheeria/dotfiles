# zmodload zsh/zprof
export EDITOR=vim
# X Development Group
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export ZSH="$XDG_CONFIG_HOME/zsh"
# Dump my completions to your cache
export ZSH_COMPDUMP="$ZSH/.zcompdump-${ZSH_VERSION}"
plugins=(z)
source $ZSH/miniomz.sh
source $ZSH/spock.zsh

# Use Vim as pager for man
export MANPAGER="vim -M +MANPAGER -"

# Homebrew
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_HINTS=1
export HOMEBREW_INSTALL_BADGE="🧉"

alias vc="vim ~/.vim/vimrc"
alias zc="vim ~/.zshrc"
alias sz="source ~/.zshrc"

# Custom scripts per directory
chpwd() {
  if [ -r $PWD/.custom.sh ]; then
    source $PWD/.custom.sh
  fi
}

# Core-JS ads
# npm set fund false
# npm set audit false
export ADBLOCK=1
export DISABLE_OPENCOLLECTIVE=1

# Fuzzy Finder written in Go
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# DO NOT TRACK
export HOMEBREW_NO_ANALYTICS=1
# Don't spy on me, Google
export GOPROXY=direct
export GOSUMDB=off
# Don't spy on me, Microsoft
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export AZURE_CORE_COLLECT_TELEMETRY=0
export AZURE_CORE_SURVEY_MESSAGE=0
# Don't spy, pretty please
export DO_NOT_TRACK=1
export NEXT_TELEMETRY_DISABLED=1

# Where to find executables
[[ "$OSTYPE" == darwin* && -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"

# Python 
export PYTHONDONTWRITEBYTECODE=1

# Je ne veux pas travailler
[ -f ~/.workrc ] && source ~/.workrc
# zprof > ~/.profiled

