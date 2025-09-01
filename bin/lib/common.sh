#!/usr/bin/env bash
# Common utilities for bin scripts

# OS detection
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

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

# Check if a command exists
has_command() {
    type "$1" &>/dev/null
}