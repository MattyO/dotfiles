export CLICOLOR=1
export TERM=screen-256color
export LSCOLORS=ExFxCxDxBxegedabagacad
export LESS="-erX"
export PAGER=less
#export WORKON_HOME=$HOME/virtenvs
#export PROJECT_HOME=$HOME/python/dev
#source /usr/local/bin/virtualenvwrapper.sh

alias ll="ls -la"
alias start_postgres="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias stop_postgres="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

#if [[ "$(uname)"  == 'Darwin' ]] ; then
#  vim(){
#    /Applications/MacVim.app/Contents/MacOS/Vim $*
#  }
#fi

if [[ "$(uname)"  == 'Linux' ]] ; then
  alias ls="ls --color"
fi

if [ -d $HOME/.profile_d/*.sh ] ; then
  for PROFILE_SCRIPT in $( ls $HOME/.profile_d/*.sh ); do
    . $PROFILE_SCRIPT
  done 
fi

PATH=$PATH:$HOME/.rvm/bin:$HOME/bin # Add RVM to PATH for scripting
PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
