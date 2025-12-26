#!/bin/bash
#
# Alfred script: List tasks
#

QUERY="${1:-}"

# Handle special "open" command
if [[ "$QUERY" == "open" ]]; then
    ~/bin/task-manager open
    # Return empty results since we're opening Notion directly
    echo '{"items":[]}'
    exit 0
fi

# Determine filter based on query
FILTER="active"
case "$QUERY" in
    all|ready|focus|triage)
        FILTER="$QUERY"
        ;;
    "")
        FILTER="active"
        ;;
    *)
        # If query doesn't match a filter, use active and let Alfred filter
        FILTER="active"
        ;;
esac

# Get tasks in JSON format
RESULT=$(~/bin/task-manager --json list "$FILTER" 2>/dev/null)

if [[ $? -ne 0 ]] || [[ -z "$RESULT" ]]; then
    # Return error item
    echo '{"items":[{"title":"Error loading tasks","subtitle":"Check your Notion API token and configuration","valid":false}]}'
    exit 0
fi

# Check if we have any results
ITEM_COUNT=$(echo "$RESULT" | jq -r '.items | length')

if [[ "$ITEM_COUNT" == "0" ]]; then
    # Add helpful message when no tasks
    echo '{"items":[{"title":"No tasks found","subtitle":"Try: tasks all, tasks triage, or task <title> to add one","valid":false}]}'
    exit 0
fi

# Output the result
echo "$RESULT"
