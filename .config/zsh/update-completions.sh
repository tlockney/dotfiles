#!/usr/bin/env zsh
# Update shell completions for installed tools
# This script should be run after installing or updating tools

# Ensure completions directory exists
[[ ! -d ~/.zsh/completions ]] && mkdir -p ~/.zsh/completions

echo "Updating shell completions..."

# Update completions only if the tool exists
if command -v rustup >/dev/null 2>&1; then
    echo "  - Updating rustup completions"
    rustup completions zsh > ~/.zsh/completions/_rustup
fi

if command -v deno >/dev/null 2>&1; then
    echo "  - Updating deno completions"
    deno completions zsh > ~/.zsh/completions/_deno
fi

if command -v uv >/dev/null 2>&1; then
    echo "  - Updating uv completions"
    uv generate-shell-completion zsh > ~/.zsh/completions/_uv
fi

if command -v mise >/dev/null 2>&1; then
    echo "  - Updating mise completions"
    mise completions zsh > ~/.zsh/completions/_mise
fi

if command -v docker >/dev/null 2>&1; then
    echo "  - Updating docker completions"
    docker completion zsh > ~/.zsh/completions/_docker
fi

if command -v wezterm >/dev/null 2>&1; then
    echo "  - Updating wezterm completions"
    wezterm shell-completion --shell zsh > ~/.zsh/completions/_wezterm
fi

echo "Completions updated successfully!"