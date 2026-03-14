#!/usr/bin/env bash
# Shared utilities for scripts that communicate with the open-agent daemon
# via a Unix socket (JSON protocol over socat/nc).
#
# Usage:
#   source "$(dirname "$0")/lib/open-agent.sh"
#   oa_init                          # uses $OPEN_AGENT_SOCK or /tmp/open-agent.sock
#   oa_init "/custom/path.sock"      # explicit socket path
#   oa_require_sock                  # exit if socket missing
#
# After init, use:
#   oa_json_escape "string"          # → "escaped\"string"
#   oa_send '{"action":"foo"}' [30]  # send message, optional timeout (default 5s)
#   oa_json_value "$json" "key"      # extract simple string value
#   oa_check_response "$json"        # check "ok":true, print error on failure

# Globals set by oa_init:
#   OA_SOCK         — resolved socket path
#   OA_SCRIPT_NAME  — basename of the calling script (for error messages)

# Initialize the open-agent connection settings.
# Args: [socket_path]  — defaults to $OPEN_AGENT_SOCK or /tmp/open-agent.sock
oa_init() {
    OA_SOCK="${1:-${OPEN_AGENT_SOCK:-/tmp/open-agent.sock}}"
    OA_SCRIPT_NAME="$(basename "$0")"
}

# Exit with an error if the agent socket doesn't exist.
oa_require_sock() {
    if [[ ! -S "$OA_SOCK" ]]; then
        echo "${OA_SCRIPT_NAME}: agent socket not found at $OA_SOCK" >&2
        exit 1
    fi
}

# Produce a JSON-quoted string (with surrounding quotes).
# Handles backslashes, double quotes, and control characters.
oa_json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\t'/\\t}"
    s="${s//$'\r'/\\r}"
    printf '"%s"' "$s"
}

# Send a JSON message to the agent socket and print the response.
# Args: <message> [timeout_seconds]  — timeout defaults to 5
# Returns non-zero on connection failure.
oa_send() {
    local msg="$1"
    local timeout="${2:-5}"

    if command -v socat &>/dev/null; then
        echo "$msg" | socat -t"$timeout" - UNIX-CONNECT:"$OA_SOCK" 2>/dev/null
    elif command -v nc &>/dev/null; then
        echo "$msg" | nc -U -w"$timeout" "$OA_SOCK" 2>/dev/null
    else
        echo "${OA_SCRIPT_NAME}: neither socat nor nc available" >&2
        return 1
    fi
}

# Extract a simple string value from flat JSON.
# Only works for unescaped string values (sufficient for agent responses).
# Args: <json_string> <key>
oa_json_value() {
    echo "$1" | grep -o "\"$2\":\"[^\"]*\"" | head -1 | sed "s/\"$2\":\"//" | sed 's/"$//'
}

# Check whether a response indicates success ("ok":true).
# On failure, prints the error field to stderr and returns 1.
oa_check_response() {
    local response="$1"
    if echo "$response" | grep -q '"ok":true'; then
        return 0
    fi
    local err
    err=$(oa_json_value "$response" "error")
    echo "${OA_SCRIPT_NAME}: ${err:-unknown error}" >&2
    return 1
}
