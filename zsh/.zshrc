export ZSH="/Users/olzhas/.oh-my-zsh"

ZSH_THEME="spock"
HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=13

plugins=(git z)

# Dump my completions to your cache
# export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

# Edit in Vim, instead of the terminal
# https://youtu.be/mz9LBUteKNo
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

# Use Vim as pager for man
export MANPAGER="vim -M +MANPAGER -"

# X Development Group
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state

# DO NOT TRACK
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_HINTS=1
export HOMEBREW_INSTALL_BADGE="🧉"
export DYLD_LIBRARY_PATH=/opt/homebrew/lib
export LIBRARY_PATH=/opt/homebrew/lib
export C_INCLUDE_PATH=/opt/homebrew/include

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

# If I'll ever write in Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

# Fuzzy Finder written in Go
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Where to find executables
export PATH="/Users/olzhas/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Python development, it couldn't function without pyenv :(
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

# Je ne veux pas travailler
[ -f ~/.workrc ] && source ~/.workrc
