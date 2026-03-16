#!/bin/bash

# Open the selected project in VS Code
# Delegates to rproj for the actual opening

set -euo pipefail

# Ensure tools installed via mise are available in Alfred's minimal environment
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# rproj open expects 'host|path' format
~/.local/bin/rproj open "$1"
