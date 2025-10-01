# Zsh configuration - modular approach
# Individual configuration files are in ~/.config/zsh/

# Helper function to source files if they exist
source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

# Load configuration modules in order
source_if_exists "$HOME/.config/zsh/init.zsh"
source_if_exists "$HOME/.config/zsh/path.zsh"
source_if_exists "$HOME/.config/zsh/history.zsh"
source_if_exists "$HOME/.config/zsh/completions.zsh"
source_if_exists "$HOME/.config/zsh/prompt.zsh"
source_if_exists "$HOME/.config/zsh/tools.zsh"
source_if_exists "$HOME/.config/zsh/aliases.zsh"