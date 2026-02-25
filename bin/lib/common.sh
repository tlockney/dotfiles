#!/usr/bin/env bash
# Common utilities for bin scripts

# OS detection
CURRENT_OS=$(uname -s)
CURRENT_ARCH=$(uname -m)
export CURRENT_OS
export CURRENT_ARCH

# Colors (auto-disabled when stdout is not a terminal)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# Logging helpers
info()    { echo -e "${BLUE}$*${NC}"; }
success() { echo -e "${GREEN}$*${NC}"; }
warn()    { echo -e "${YELLOW}$*${NC}" >&2; }
error()   { echo -e "${RED}Error: $*${NC}" >&2; exit 1; }

# Print consistent section headers
print_section() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# Run a command with status output and error handling
run_step() {
    local cmd="$1"
    local desc="$2"

    echo "→ $desc"
    if ! eval "$cmd"; then
        echo "⚠️  Warning: Failed to $desc"
        return 1
    fi
    return 0
}

# Check if a command exists (POSIX-compliant)
has_command() {
    command -v "$1" >/dev/null 2>&1
}

# Require a command or exit with install hint
# Usage: require_command "yt-dlp" "brew install yt-dlp"
require_command() {
    local cmd="$1"
    local hint="${2:-}"
    if ! has_command "$cmd"; then
        local msg="Required command not found: $cmd"
        if [[ -n "$hint" ]]; then
            msg="$msg (install: $hint)"
        fi
        error "$msg"
    fi
}

# Guard: exit if not running on macOS
require_macos() {
    if [[ "$CURRENT_OS" != "Darwin" ]]; then
        error "This script only works on macOS"
    fi
}