# Call and initialize Powerline Shell:
# https://github.com/b-ryan/powerline-shell

# Copy configuration from:
# https://github.com/carlosplusplus/dot-files/blob/master/powerline-shell-config.json

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# For more prompt coolness, check out Halloween Bash:
# http://xta.github.io/HalloweenBash/

# If you break your prompt, just delete the last thing you did.
# And that's why it's good to keep your dotfiles in git too.

# Environment Variables
# =====================
# Library Paths
# These variables tell your shell where they can find certain
# required libraries so other programs can reliably call the variable name
# instead of a hardcoded path.

# NODE_PATH
export NODE_PATH="/usr/local/share/npm/bin:/usr/local/lib/node:/usr/local/lib/node_modules"
# PY_PATH
export PY_PATH="~/Library/Python/3.6/bin"

# Use python3 as the default.
alias python=python3
alias pip=pip3

# Those NODE & Python Paths won't break anything even if you
# don't have NODE or Python installed. Eventually you will and
# then you don't have to update your bash_profile

# Configurations

# GIT_MERGE_AUTO_EDIT
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Editors
# Tells your shell that when a program requires various editors, use sublime.
# The -w flag tells your shell to wait until sublime exits
export VISUAL="subl -w"
export SVN_EDITOR="subl -w"
export GIT_EDITOR="subl -w"
export EDITOR="subl -w"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Paths

# The USR_PATHS variable will just store all relevant /usr paths for easier usage
# Each path is seperate via a : and we always use absolute paths.

# A bit about the /usr directory
# The /usr directory is a convention from linux that creates a common place to put
# files and executables that the entire system needs access too. It tries to be user
# independent, so whichever user is logged in should have permissions to the /usr directory.
# We call that /usr/local. Within /usr/local, there is a bin directory for actually
# storing the binaries (programs) that our system would want.
# Also, Homebrew adopts this convetion so things installed via Homebrew
# get symlinked into /usr/local
export USR_PATHS="/usr/local/bin:/usr/local:/usr/local/sbin:/usr/bin"
export PSQL_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"

# Hint: You can interpolate a variable into a string by using the $VARIABLE notation as below.

# We build our final PATH by combining the variables defined above
# along with any previous values in the PATH variable.

# Our PATH variable is special and very important. Whenever we type a command into our shell,
# it will try to find that command within a directory that is defined in our PATH.
# Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
export PATH="$PSQL_PATH:$USR_PATHS:$NODE_PATH:$PY_PATH:$PATH"

# If you go into your shell and type: $PATH you will see the output of your current path.

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desktop.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# This function is used to post to Octopress.
# function update_blog {
#   cd /Users/carloslazo/Development/Blog/cjlwired.github.io
#   rake generate
#   rake deploy
#   git add .
#   git commit -am $@
#   git push
# }

# For running bundle exec
function be {
  bundle exec $@
}

# Aliases
# =====================
# LS
alias l='ls -alrth'

# Hidden Files
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Git
alias gst="git status"
alias gl="git pull"
alias gp="git push"
alias gd="git diff | mate"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"

# Heroku
alias gph="git push heroku"

# Postgresql
alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg-stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Final Configurations and Plugins
# =====================

# Git Bash Completion
# Will activate bash git completion if installed
# via homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Docker Configuration
# eval "$(docker-machine env default)"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
export PATH="/usr/local/opt/icu4c/bin:$PATH"

# Suppress ZSH default warning for Mac OSX.
export BASH_SILENCE_DEPRECATION_WARNING=1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# NVM

# lazyload nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

lazynvm() {
  unset -f nvm node npm npx yarn
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}

yarn() {
  lazynvm
  yarn $@
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
