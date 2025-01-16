emulate sh -c 'source ~/.profile'
if [[ -x $HOME/.local/bin/mise ]]; then
    eval "$($HOME/.local/bin/mise activate zsh)"
fi
