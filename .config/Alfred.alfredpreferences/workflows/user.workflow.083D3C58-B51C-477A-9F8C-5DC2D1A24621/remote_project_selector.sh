#!/bin/bash

# VS Code Remote Project Selector for Alfred
# Based on the rcode script but adapted for Alfred workflow

set -euo pipefail

# Defaults
DEFAULT_HOST="workmbp"
DEFAULT_DIR="/Users/thomas.lockney/src/metron"

# Get parameters from Alfred
QUERY="${1:-}"
REMOTE_HOST="${alfred_remote_host:-$DEFAULT_HOST}"
REMOTE_DIR="${alfred_remote_dir:-$DEFAULT_DIR}"

# Parse query for host override
if [[ -n "$QUERY" && "$QUERY" =~ ^@(.+) ]]; then
    REMOTE_HOST="${BASH_REMATCH[1]}"
    QUERY=""
fi

# Test SSH connection
if ! ssh -o BatchMode=yes -o ConnectTimeout=2 "$REMOTE_HOST" "test -d '$REMOTE_DIR'" 2>/dev/null; then
    cat << EOF
{"items": [{
    "title": "Connection Error",
    "subtitle": "Cannot connect to $REMOTE_HOST or directory $REMOTE_DIR doesn't exist",
    "valid": false,
    "icon": {"path": "error.png"}
}]}
EOF
    exit 0
fi

# Get projects
projects=$(ssh "$REMOTE_HOST" "find '$REMOTE_DIR' -maxdepth 1 -mindepth 1 -type d -not -name '.*' | sort" 2>/dev/null)

if [[ -z "$projects" ]]; then
    cat << EOF
{"items": [{
    "title": "No Projects Found",
    "subtitle": "No projects found in $REMOTE_DIR on $REMOTE_HOST",
    "valid": false,
    "icon": {"path": "error.png"}
}]}
EOF
    exit 0
fi

# Generate Alfred JSON output
echo '{"items": ['

first=true
while IFS= read -r project; do
    project_name=$(basename "$project")
    
    # Filter by query if provided
    if [[ -n "$QUERY" ]] && [[ ! "$project_name" =~ $QUERY ]]; then
        continue
    fi
    
    if [[ "$first" != "true" ]]; then
        echo ","
    fi
    first=false
    
    cat << EOF
{
    "uid": "$project_name",
    "title": "$project_name",
    "subtitle": "Open in VS Code: $project",
    "arg": "$REMOTE_HOST|$project",
    "autocomplete": "$project_name",
    "icon": {"path": "vscode.png"}
}
EOF
done <<< "$projects"

echo ']}'