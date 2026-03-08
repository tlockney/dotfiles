#!/bin/bash

# Add a new task via task-manager
# Delegates to task-manager; passes title through for Alfred notification

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Add the task (errors go to stderr, stdout silenced)
~/bin/task-manager add "$1" >/dev/null

# Pass through title for notification
echo "$1"
