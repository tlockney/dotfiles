# Initialize profile settings for zsh
# This file is read before .zshrc for login shells

# Source the common profile if it exists
[[ -f ~/.profile ]] && source ~/.profile

# Handle Homebrew initialization on macOS if it exists
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi