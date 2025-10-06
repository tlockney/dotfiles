# Early environment setup
# This file loads before init.zsh to set up variables needed for completion paths

# System information - detect OS and architecture
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

# Set up homebrew environment early (needed for completion paths)
if [[ "$CURRENT_OS" == "Darwin" ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  BREW_PREFIX="$(brew --prefix)"

  # Add brew completions to fpath before compinit runs
  [[ -d "$BREW_PREFIX/share/zsh-completions" ]] && fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
fi
