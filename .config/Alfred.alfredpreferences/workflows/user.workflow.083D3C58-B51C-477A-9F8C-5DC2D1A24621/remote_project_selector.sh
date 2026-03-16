#!/bin/bash

# VS Code Remote Project Selector for Alfred
# Delegates to rproj for project discovery

set -euo pipefail

# Ensure tools installed via mise are available in Alfred's minimal environment
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# Get parameters from Alfred
QUERY="${1:-}"
REMOTE_HOST="${remote_host:-}"

# Build rproj command
RPROJ_CMD=(~/.local/bin/rproj list --json)

# Add host override if provided via Alfred variable or @host syntax
if [[ -n "$QUERY" && "$QUERY" =~ ^@(.+) ]]; then
    RPROJ_CMD+=(-h "${BASH_REMATCH[1]}")
    QUERY=""
elif [[ -n "$REMOTE_HOST" ]]; then
    RPROJ_CMD+=(-h "$REMOTE_HOST")
fi

# Add query filter if provided
if [[ -n "$QUERY" ]]; then
    RPROJ_CMD+=(-q "$QUERY")
fi

# Execute rproj and return its JSON output
"${RPROJ_CMD[@]}"
