# X Development Group
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state

export ZSH="$XDG_CONFIG_HOME/zsh"
# Dump my completions to your cache
export ZSH_COMPDUMP=$ZSH/.zcompdump-${ZSH_VERSION}
plugins=(z)
source $ZSH/miniomz.sh
source $ZSH/spock.zsh

## History file configuration
HISTFILE="$XDG_CONFIG_HOME/zsh/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# Edit in Vim, instead of the terminal
# https://youtu.be/mz9LBUteKNo
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

# Use Vim as pager for man
export MANPAGER="vim -M +MANPAGER -"


# DO NOT TRACK
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_HINTS=1
export HOMEBREW_INSTALL_BADGE="🧉"

alias vc="vim ~/.vim/vimrc"
alias zc="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias bl="vim -u ~/.personal/bl/vimrc ~/.personal/bl/blaue_laube.md"

# Reinventing the wheel
alias start="open -a "
finish() {
    osascript -e "quit app \"$1\""
}

# Custom scripts per directory
chpwd() {
  if [ -r $PWD/.custom.sh ]; then
    source $PWD/.custom.sh
  fi
}

# Merge latest changes to the current branch
glatest() {
  keep_branch=$(git_current_branch)
  git checkout $(git_main_branch)
  git pull -p
  git checkout $keep_branch
  git merge $(git_main_branch)
}

# Node stuff, slow af
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

# Fuzzy Finder written in Go
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Don't spy on me, Google
export GOPROXY=direct
export GOSUMDB=off

# Where to find executables
export PATH="/usr/local/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/openjdk@11/bin:$PATH"

# Python development, it couldn't function without pyenv :(
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"
export PYTHONDONTWRITEBYTECODE=1

# Je ne veux pas travailler
[ -f ~/.workrc ] && source ~/.workrc
