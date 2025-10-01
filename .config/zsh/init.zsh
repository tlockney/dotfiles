# Basic zsh initialization and completion system

# Initialize completion system once (cached for performance)
[[ ! -d ~/.zsh/completions ]] && mkdir -p ~/.zsh/completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit

# Cache compinit for 24 hours to improve startup time
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -u
else
  compinit -C -u  # Skip security check if dump is recent
fi

# Completions are managed by ~/.config/zsh/update-completions.sh
# Run that script after installing or updating tools to regenerate completions

# Set emacs keybindings
set -o emacs

# Key bindings for better navigation
bindkey '^[[1;5C' forward-word     # Ctrl+right arrow: move forward one word
bindkey '^[[1;5D' backward-word    # Ctrl+left arrow: move backward one word
bindkey '^[[H' beginning-of-line   # Home key: beginning of line
bindkey '^[[F' end-of-line         # End key: end of line
bindkey '^[[3~' delete-char        # Delete key

# Add useful zsh options
setopt AUTO_CD                  # If a command is a directory name, cd to it
setopt AUTO_PUSHD               # Push dirs to the stack automatically
setopt PUSHD_IGNORE_DUPS        # Don't push multiple copies of the same directory
setopt PUSHD_SILENT             # Don't print the directory stack after pushd or popd
setopt CORRECT                  # Try to correct command spelling
setopt NO_FLOW_CONTROL          # Disable flow control (^S/^Q)
setopt INTERACTIVE_COMMENTS     # Allow comments even in interactive shells