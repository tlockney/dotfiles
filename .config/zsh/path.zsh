# Path configuration and management

# Prevent duplicate path entries
typeset -U path

# Helper function to prepend to PATH
function prepend_to_path {
  # Only add path if it exists and is not already in the path
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    path=($1 $path)
    export PATH
  fi
}

# Standard directories
prepend_to_path /usr/local/bin
prepend_to_path /usr/local/sbin
prepend_to_path $HOME/bin
prepend_to_path $HOME/.local/bin

# Use macOS path_helper if available
if [[ -f "/usr/libexec/path_helper" ]]; then
  eval "$(/usr/libexec/path_helper)"
fi