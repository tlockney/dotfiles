# Path configuration and management

# Prevent duplicate path entries
typeset -U path

# Helper function to prepend to PATH
function prepend_to_path {
  # Only add path if it exists and is not already in the path
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    # shellcheck disable=SC2206  # path is a zsh array tied to PATH
    path=($1 $path)
    export PATH
  fi
}

# Note: User directories ($HOME/bin and $HOME/.local/bin) are added in tools.zsh
# AFTER mise activates to ensure they appear at the front of PATH.
# This is necessary because mise's hook-env replaces PATH entirely and would
# otherwise move user directories to the end.

# Note: path_helper is already called by brew shellenv in env.zsh
# Calling it again here would move user paths to the end of PATH