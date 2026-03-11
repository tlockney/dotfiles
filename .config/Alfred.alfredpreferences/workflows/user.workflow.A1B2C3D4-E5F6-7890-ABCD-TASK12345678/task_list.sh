#!/bin/bash

# List tasks as Alfred JSON
# Delegates to task-manager for Notion data

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Execute task-manager and return its JSON output
~/bin/task-manager --json list
