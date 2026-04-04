#!/bin/bash

# List today's meetings as Alfred JSON
# Delegates to mtg for calendar data

set -euo pipefail

# Ensure tools installed via mise are available in Alfred's minimal environment
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

QUERY="${1:-}"

# Build mtg command
MTG_CMD=(~/bin/mtg list --json)

# Add query filter if provided
if [[ -n "$QUERY" ]]; then
    MTG_CMD+=(-q "$QUERY")
fi

# Execute mtg and return its JSON output
"${MTG_CMD[@]}"
