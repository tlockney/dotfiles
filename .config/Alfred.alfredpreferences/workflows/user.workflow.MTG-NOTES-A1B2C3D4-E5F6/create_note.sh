#!/bin/bash

# Create a meeting note and open it in Obsidian
# Delegates to mtg for note creation

set -euo pipefail

# Ensure tools installed via mise are available in Alfred's minimal environment
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

~/bin/mtg create --uid "$1"
