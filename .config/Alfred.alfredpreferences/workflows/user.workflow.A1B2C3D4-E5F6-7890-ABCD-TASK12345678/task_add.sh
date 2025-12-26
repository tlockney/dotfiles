#!/bin/bash
#
# Alfred script: Add a new task
#

QUERY="$1"

if [[ -z "$QUERY" ]]; then
    echo "No task title provided"
    exit 1
fi

# Call the task-manager script
~/bin/task-manager add "$QUERY" >/dev/null 2>&1

# Output the title for the notification
echo "$QUERY"
