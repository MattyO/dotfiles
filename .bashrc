# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S "

#command_exe_time () {
#    echo "debug";
#    local end=$(TZ=UTC date "+%s");
#    echo "$end";
#    local start=$(history 1 | awk '{print $2}');
#    local start_time=$(date -d "$start" "+%s");
#    echo "$start";
#    echo "$start_time";
#    echo "$diff";
#    echo "end debug";
#    local diff=$((end - start_time));
#    echo "$diff"
#}

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#trap 'echo $BASH_COMMAND' DEBUG  # example only set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\\[\033[00m\] $ "


#counter=0
#PROMPT_COMMAND='counter=$((counter+1))'

ps1 () {
  red=\[\033[91m\]          # color 1 Red
  GIT="\[\033[32m\]"        # color 2  (#26A98B) - Green
  YELLOW="\[\033[33m\]"        # color 3  (#EDB54B) - Yellow
  USER="\[\033[34m\]"       # color 4  (#195465) - Blue
  HOST="\[\033[34m\]"       # color 4  (#195465) - Blue
  PURPLE="\[\033[35m\]"     # color 5  (#4E5165) - Magenta
  DIR="\[\033[36m\]"        # color 6  (#33859D) - Cyan
  PROMPT="\[\033[97m\]"     # color 7  (#98D1CE) - Brightest
  TS="\[\033[90m\]"         # color 8 - Dark gray
  ENV_CONTEXT="\[\033[91m\]"       # color 9  (#D26939) - Bright orange
  TS="\[\033[90m\]"         # color 13 (#888BA5) - Gray
  HR="\[\033[94m\]"         # color 12 (#093748) - Dark blue
  RESET="\[\033[00m\]"

  asdf_versions="$(asdf current 2>/dev/null | while read -r line; do
      if [[ -n $line ]]; then
          lang=$(echo "$line" | awk '{print $1}')
          version=$(echo "$line" | awk '{print $2}')

        # Skip if version doesn't match semantic versioning pattern
        [[ ! $version =~ ^[0-9]+(\.[0-9]+)*$ ]] && continue
        [[ $version == "______" ]] && continue

          case $lang in
              "ruby")       lang="" ;;
              "go")         lang="" ;;
              "python")     lang="" ;;
              "npm")        lang="" ;;
              "nodejs")     lang="󰎙" ;;
              "terraform")  lang="" ;;
          esac
          printf "%s:%s " "$lang" "$version"
      fi
  done)"
  if [ -n "$last_command_start" ]; then
      current_time="$(date "+%s%N")";
      diff_time="$(( ($current_time-$last_command_start) /100000 ))";
      padded_diff_time=$(printf "%05d" "$diff_time")
      time_output="[${padded_diff_time:0:1}.${padded_diff_time:1} sec]"

      local execution_time_line="\n$HR┗$(printf -- ━%.s $(seq -s ' ' $(($COLUMNS-${#time_output}-5))))$RESET$PURPLE$time_output$RESET$HR━━━┛$RESET\n\n\n"

  fi

  if git rev-parse --git-dir > /dev/null 2>&1; then
      git_info="($(parse_git_branch) ⧗ $(~/bin/last-commit)) "
  fi

  host_info="⌜$(whoami)@$(hostname)⌟"
  directory_info="📁 ${PWD/#$HOME/\~}"

#${debian_chroot:+($debian_chroot)}

   primary_line="$HR┍━$RESET $USER$host_info$RESET $YELLOW$directory_info$RESET $GIT$git_info$RESET$HR┆ $RESET$ENV_CONTEXT$asdf_versions$RESET"

   primary_padded_line="$primary_line$HR$(printf -- ━%.s $(seq -s ' ' $(($COLUMNS-${#primary_line}+ 129))))$RESET$PURPLE[\t]$RESET$HR━━━┓$RESET"

   echo "$execution_time_line$primary_padded_line\n 󱞪 "

}

if [ "$color_prompt" = yes ]; then
    PS1="$(ps1)"
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch) \n\$> " # | \$(~/bin/last-commit)
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias be='bundle exec'

alias diff='git diff'
alias status='git status'
alias add='git add -A'
alias commit='git commit -m'
alias branch='git branch'
alias co='git checkout'
alias push='git push origin $(git symbolic-ref --short HEAD)'

alias overmind='~/bin/overmind'
alias fd='fdfind'
alias tests='/home/matty/workspace/python-vim-plugin/env/bin/python /home/matty/workspace/python-vim-plugin/start_everything.py'
alias tree='tree -I "env|__pycache__|vendor"'
alias stop_spring="kill $(ps -afe | grep spring | awk '{ print $2 }')"
alias stop_jobs="kill $(jobs -p)"
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function cd() {
  builtin cd "$@"

  ## Default path to virtualenv in your projects
  DEFAULT_ENV_PATH="./env"

  ## If env folder is found then activate the vitualenv
  function activate_venv() {
    if [[ -f "${DEFAULT_ENV_PATH}/bin/activate" ]] ; then
      source "${DEFAULT_ENV_PATH}/bin/activate"
    fi
  }

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    activate_venv
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate then run a new env folder check
      parentdir="$(dirname ${VIRTUAL_ENV})"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
        activate_venv
      fi
  fi
}

function project(){
	~/workspace/project-cmd/env/bin/python ~/workspace/project-cmd/project/main.py $@;
	[ "$1" != 'list' ] && cd "/home/matty/workspace/$1"
}

# Added by `rbenv init` on Tue Jul  9 05:48:11 PM EDT 2024
eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.asdf/asdf.sh"

export PGHOST=localhost
export PGUSER=postgres
export EDITOR=vim

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
preexec() { last_command_start="$(date "+%s%N")";}
precmd() { PS1="$(ps1)" ;}

