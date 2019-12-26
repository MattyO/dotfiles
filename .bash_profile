export PATH="$HOME/.geckodriver:$PATH"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias be='bundle exec'

export PATH=$PATH:/home/matt/anaconda3/bin

alias gs='git status'
alias  gb='git branch'

cd() {
	builtin cd "$@"
	if [[ -z "$VIRTUAL_ENV" ]] ; then
		## If env folder is found then activate the vitualenv
		if [[ -d ./env ]] ; then
			source ./env/bin/activate
		fi
	else
		## check the current folder belong to earlier VIRTUAL_ENV folder
		# if yes then do nothing
		# else deactivate
		parentdir="$(dirname "$VIRTUAL_ENV")"
		if [[ "$PWD"/ != "$parentdir"/* ]] ; then
			deactivate
		fi
	fi

	# Do whatever you want here
}
