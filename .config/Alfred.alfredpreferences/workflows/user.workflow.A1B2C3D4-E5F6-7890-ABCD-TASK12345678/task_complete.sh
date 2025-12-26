#!/bin/bash
#
# Alfred script: Complete a task
#

TASK_ID="$1"

if [[ -z "$TASK_ID" ]]; then
    echo "No task ID provided"
    exit 1
fi

# Call the task-manager script
~/bin/task-manager complete "$TASK_ID" >/dev/null 2>&1

exit 0
