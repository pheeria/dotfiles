export ZSH="/Users/o.askar/.oh-my-zsh"

ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "pi" ) #robbyrussell" "spaceship" )

HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=13

plugins=(git zsh-autosuggestions z vi-mode)
MODE_INDICATOR="%{$fg_bold[magenta]%}%{$fg[magenta]%}NORMAL%{$reset_color%}"

source $ZSH/oh-my-zsh.sh

alias corsdev="open -n -a /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary --args --disable-web-security"
alias vc="vim ~/Documents/Workspace/dotfiles/vim/vimrc"
alias zc="vim ~/.zshrc"

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

finish() {
    osascript -e "quit app \"$1\""
}
