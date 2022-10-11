export ZSH="/Users/o.askar/.oh-my-zsh"

ZSH_THEME="spock"
HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=13

plugins=(git z)

source $ZSH/oh-my-zsh.sh

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

# use Vim as pager for man
export MANPAGER="vim -M +MANPAGER -"

# DO NOT TRACK
export PATH=$PATH:/opt/homebrew/bin:/Users/o.askar/Library/Python/3.8/bin
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

# If I'll ever write in Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

# Fuzzy Finder written in Go
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Node stuff, slow af
export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

# Je ne veux pas travailler
[ -f ~/.workrc ] && source ~/.workrc
export GENSIM_DATA_DIR=~/.personal/gensim
if [ -f ~/.kube/aliases-staging ]; then source ~/.kube/aliases-staging; fi
