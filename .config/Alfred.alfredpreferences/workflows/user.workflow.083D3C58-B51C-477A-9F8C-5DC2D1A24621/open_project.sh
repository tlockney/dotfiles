#!/bin/bash

# Open the selected project in VS Code

set -euo pipefail

# Parse the argument (format: "host|path")
IFS='|' read -r REMOTE_HOST PROJECT_PATH <<< "$1"

# Open in VS Code
code --remote "ssh-remote+$REMOTE_HOST" "$PROJECT_PATH"
