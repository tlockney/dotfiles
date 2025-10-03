# Tool initialization and environment setup
# Note: CURRENT_OS, CURRENT_ARCH, and BREW_PREFIX are set in env.zsh

# Terminal configuration
[[ "$TERM_PROGRAM" == "ghostty" ]] && export TERM="xterm-256color"

# 1Password SSH Agent configuration
[[ "$CURRENT_OS" == "Darwin" ]] && export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
[[ "$CURRENT_OS" == "Linux" ]] && export SSH_AUTH_SOCK="$HOME/.1password/agent.socket"

# Editor configuration
if command -v emacsclient >/dev/null 2>&1; then
  export EDITOR="emacsclient -a 'emacs'"
  [[ "$(command -v code)" ]] && export ALTERNATE_EDITOR="code"
elif command -v code >/dev/null 2>&1; then
  export EDITOR="code"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi

# Locale settings - set default but don't override if already set
: ${LC_ALL:=en_US.UTF-8}
: ${LANG:=en_US.UTF-8}
: ${LANGUAGE:=en_US.UTF-8}
export LC_ALL LANG LANGUAGE

# Initialize mise tool version manager if installed
# Note: User directories ($HOME/bin and $HOME/.local/bin) are configured in .mise.toml
# to be prepended to PATH automatically
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
elif [[ -x $HOME/.local/bin/mise ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

# Zsh autosuggestions (BREW_PREFIX set in env.zsh)
ZSH_AUTO_SCRIPT="zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -e "$BREW_PREFIX/share/$ZSH_AUTO_SCRIPT" ]] && source "$BREW_PREFIX/share/$ZSH_AUTO_SCRIPT"
[[ -e /usr/share/$ZSH_AUTO_SCRIPT ]] && source /usr/share/$ZSH_AUTO_SCRIPT

# Zsh syntax highlighting
[[ -d "$BREW_PREFIX/share/zsh-syntax-highlighting" ]] && {
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # Disable underline
  (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none
}

# Set up XDG runtime directory if not already set
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
  [[ "$CURRENT_OS" == "Linux" ]] && XDG_RUNTIME_DIR=/run/user/$(id -u)
  [[ "$CURRENT_OS" == "Darwin" ]] && {
    XDG_RUNTIME_DIR="${TMPDIR%/}/user/$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
  }

  # Only set if directory exists and is writable
  if [[ -d "$XDG_RUNTIME_DIR" && -w "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

# Configure Emacs socket name based on platform
[[ "$CURRENT_OS" = "Darwin" ]] && export EMACS_SOCKET_NAME="${TMPDIR:-/tmp}emacs$(id -u)/server"
[[ "$CURRENT_OS" = "Linux" ]] && export EMACS_SOCKET_NAME="${XDG_RUNTIME_DIR:-/tmp}/emacs/server"

# Set up cargo
[[ -d "$HOME/.cargo" ]] && source "$HOME/.cargo/env"

# Set up Java environment
export JAVA_OPTIONS="-Djava.awt.headless=true"
# Try to detect Java home across different platforms
[[ "$CURRENT_OS" == "Darwin" && -x /usr/libexec/java_home ]] && {
  export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
}
[[ "$CURRENT_OS" == "Linux" ]] && {
  # Try different common Linux Java locations in order of preference
  [[ -d "/usr/lib/jvm/default-java" ]] && export JAVA_HOME=/usr/lib/jvm/default-java ||
  [[ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]] && export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 ||
  [[ -L "/etc/alternatives/java_sdk" ]] && export JAVA_HOME=$(readlink -f /etc/alternatives/java_sdk)
}

# Add Java to PATH if JAVA_HOME was found
[[ -n "$JAVA_HOME" ]] && prepend_to_path "$JAVA_HOME/bin"

# Set up Go if installed
[[ -d "$HOME/go" ]] && { export GOPATH="$HOME/go"; prepend_to_path "$GOPATH/bin"; }

# opam configuration
[[ -r ~/.opam/opam-init/init.zsh ]] && source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

# 1Password integration
if command -v op >/dev/null 2>&1; then
  eval "$(op completion zsh)"
  compdef _op op
fi
[[ -f ~/.config/op/plugins.sh ]] && source ~/.config/op/plugins.sh

# Atuin shell history
[[ -d "$HOME/.atuin/bin" ]] && {
  prepend_to_path "$HOME/.atuin/bin"
  eval "$(atuin init zsh)"
}

# Set up PNPM if installed
(command -v pnpm >/dev/null 2>&1 || [[ -d "$HOME/Library/pnpm" ]] || [[ -d "$HOME/.local/share/pnpm" ]]) && {
  # Set PNPM_HOME based on platform
  [[ "$CURRENT_OS" = "Darwin" ]] && export PNPM_HOME="$HOME/Library/pnpm"
  [[ "$CURRENT_OS" = "Linux" ]] && export PNPM_HOME="$HOME/.local/share/pnpm"

  # Create directory if it doesn't exist and add to PATH
  mkdir -p "$PNPM_HOME" 2>/dev/null || true
  prepend_to_path "$PNPM_HOME"
}

# Add Homebrew-specific paths on macOS
[[ -d "$BREW_PREFIX/opt/uutils-coreutils/libexec/uubin" ]] && prepend_to_path "$BREW_PREFIX/opt/uutils-coreutils/libexec/uubin"
[[ -d "$BREW_PREFIX/opt/libpq/bin" ]] && prepend_to_path "$BREW_PREFIX/opt/libpq/bin"

# Brew wrap support if available
[[ -f "$BREW_PREFIX/etc/brew-wrap" ]] && source "$BREW_PREFIX/etc/brew-wrap"

# FZF integration
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Source optional configuration files
[[ -e "$HOME/.shellfishrc" ]] && source "$HOME/.shellfishrc"

# Claude CLI alias
[[ -x "$HOME/.claude/local/claude" ]] && alias claude="$HOME/.claude/local/claude"

prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
