#!/bin/bash

# VS Code Remote Project Selector for Alfred
# Delegates to rproj for project discovery

set -euo pipefail

# Get parameters from Alfred
QUERY="${1:-}"
REMOTE_HOST="${alfred_remote_host:-}"
REMOTE_DIR="${alfred_remote_dir:-}"

# Build rproj command
RPROJ_CMD=(~/bin/rproj list --json)

# Add host override if provided via Alfred variable or @host syntax
if [[ -n "$QUERY" && "$QUERY" =~ ^@(.+) ]]; then
    RPROJ_CMD+=(-h "${BASH_REMATCH[1]}")
    QUERY=""
elif [[ -n "$REMOTE_HOST" ]]; then
    RPROJ_CMD+=(-h "$REMOTE_HOST")
fi

# Add directory override if provided
if [[ -n "$REMOTE_DIR" ]]; then
    RPROJ_CMD+=(-d "$REMOTE_DIR")
fi

# Add query filter if provided
if [[ -n "$QUERY" ]]; then
    RPROJ_CMD+=(-q "$QUERY")
fi

# Execute rproj and return its JSON output
"${RPROJ_CMD[@]}"
