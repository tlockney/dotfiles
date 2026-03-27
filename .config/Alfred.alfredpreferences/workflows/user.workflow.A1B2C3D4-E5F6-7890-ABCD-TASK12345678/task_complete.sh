#!/bin/bash

# Complete a task via task-manager
# Uses --json to extract the title for Alfred notification

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

RESULT=$(~/bin/task-manager --json complete "$1")
echo "$RESULT" | jq -r '.title // "Task"'
