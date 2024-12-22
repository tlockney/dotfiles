if [ -z "$XDG_RUNTIME_DIR" ]; then
  XDG_RUNTIME_DIR=/run/user/$(id -u)
  if [ -d "$XDG_RUNTIME_DIR" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -p)

# set up homebrew paths
if [[ $CURRENT_OS = "Darwin" ]]; then
	if [[ -d /opt/homebrew ]]; then
		eval $(/opt/homebrew/bin/brew shellenv)
	fi
	if [[ -d /usr/local/Cellar ]]; then
		eval $(/usr/local/bin/brew shellenv)
	fi
fi

if [[ -f /etc/manpaths ]]; then
	for dir in $(cat /etc/manpaths); do
		export MANPATH="$MANPATH:$dir"
	done
fi

# set up cargo
if [[ -d "$HOME/.cargo" ]]; then
	. "$HOME/.cargo/env"
fi
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

if [[ -d "$HOME/.atuin" ]]; then
    . "$HOME/.atuin/bin/env"
fi
