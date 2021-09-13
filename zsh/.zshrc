export ZSH="/home/joaom/.oh-my-zsh"
export PATH=$HOME/.local/bin:$PATH

export GO111MODULE='on'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export EDITOR='nvim'

export DOTFILES=$HOME/.dotfiles
export PROJECTS_DIR=$HOME/dev
export JS_PROJECTS=$HOME/dev/js-projects
export RCT_PROJECTS=$HOME/dev/rct-projects
export GO_PROJECTS=$HOME/dev/golang

ZSH_THEME="spaceship"

# GIT ALIAS
alias gs='git status'
alias gc='git commit'
alias gpush='git push'
alias gpull='git pull'
alias gd='git diff'
alias gadd='git add .'

alias gweb='gh repo view --web'

alias dots='cd $DOTFILES'

__new_branch() {git checkout -b $1}
alias gbn=__new_branch


alias ai='sudo apt install '
alias au='sudo apt update && sudo apt-get upgrade'

source $DOTFILES/zsh/alias_w.zsh

plugins=(nvm ssh-agent fast-syntax-highlighting zsh-autosuggestions zsh-completions)

source $ZSH/oh-my-zsh.sh

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  node          # Node.js section
  golang        # Go section
  docker        # Docker section
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
