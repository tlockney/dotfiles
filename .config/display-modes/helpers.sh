#!/bin/bash
# Display Mode Switching - Helper Functions
# Source this file in mode scripts: source "$(dirname "$0")/helpers.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# =============================================================================
# DDC INPUT SWITCHING
# =============================================================================

# Switch Dell monitor input via DDC (local)
switch_dell_local() {
    local input_value="$1"
    if [[ -n "$input_value" ]]; then
        betterdisplaycli set -nameLike="$DELL_NAME" -ddc -vcp=0x60 -value="$input_value"
    fi
}

# Switch BenQ monitor input via DDC (local)
switch_benq_local() {
    local input_value="$1"
    if [[ -n "$input_value" ]]; then
        betterdisplaycli set -nameLike="$BENQ_NAME" -ddc -vcp=0x60 -value="$input_value"
    fi
}

# Switch Dell monitor input via HTTP (remote)
switch_dell_remote() {
    local host="$1"
    local input_value="$2"
    if [[ -n "$input_value" ]]; then
        curl -s "http://${host}:${BD_PORT}/set?nameLike=${DELL_NAME}&ddc&vcp=0x60&value=${input_value}" > /dev/null
    fi
}

# Switch BenQ monitor input via HTTP (remote)
switch_benq_remote() {
    local host="$1"
    local input_value="$2"
    if [[ -n "$input_value" ]]; then
        curl -s "http://${host}:${BD_PORT}/set?nameLike=${BENQ_NAME}&ddc&vcp=0x60&value=${input_value}" > /dev/null
    fi
}

# =============================================================================
# DISPLAY CONNECTION MANAGEMENT
# =============================================================================
# These functions connect/disconnect displays from macOS's perspective
# "Disconnecting" removes the display from the display layout so macOS
# doesn't try to use it when that input isn't selected on the monitor

# Connect a display locally
connect_display_local() {
    local display_name="$1"
    betterdisplaycli set -nameLike="$display_name" -connected=on 2>/dev/null || true
}

# Disconnect a display locally
disconnect_display_local() {
    local display_name="$1"
    betterdisplaycli set -nameLike="$display_name" -connected=off 2>/dev/null || true
}

# Connect a display via HTTP (remote)
connect_display_remote() {
    local host="$1"
    local display_name="$2"
    curl -s "http://${host}:${BD_PORT}/set?nameLike=${display_name}&connected=on" > /dev/null 2>&1 || true
}

# Disconnect a display via HTTP (remote)
disconnect_display_remote() {
    local host="$1"
    local display_name="$2"
    curl -s "http://${host}:${BD_PORT}/set?nameLike=${display_name}&connected=off" > /dev/null 2>&1 || true
}

# =============================================================================
# COMPOUND OPERATIONS
# =============================================================================

# Connect both displays locally
connect_both_local() {
    connect_display_local "$DELL_NAME"
    connect_display_local "$BENQ_NAME"
}

# Disconnect both displays locally
disconnect_both_local() {
    disconnect_display_local "$DELL_NAME"
    disconnect_display_local "$BENQ_NAME"
}

# Connect both displays on remote host
connect_both_remote() {
    local host="$1"
    connect_display_remote "$host" "$DELL_NAME"
    connect_display_remote "$host" "$BENQ_NAME"
}

# Disconnect both displays on remote host
disconnect_both_remote() {
    local host="$1"
    disconnect_display_remote "$host" "$DELL_NAME"
    disconnect_display_remote "$host" "$BENQ_NAME"
}

# =============================================================================
# MACHINE DETECTION
# =============================================================================

# Detect which machine this script is running on
get_current_machine() {
    local hostname=$(hostname -s | tr '[:upper:]' '[:lower:]')
    case "$hostname" in
        *mini*) echo "mini" ;;
        *mbp*|*macbook*pro*) echo "mbp" ;;
        *air*|*mba*) echo "air" ;;
        *) echo "unknown" ;;
    esac
}

# Check if a remote host is reachable
is_host_reachable() {
    local host="$1"
    curl -s --connect-timeout 2 "http://${host}:${BD_PORT}/get?proAvailable" > /dev/null 2>&1
}

# =============================================================================
# LOGGING
# =============================================================================

log_info() {
    echo "[$(date '+%H:%M:%S')] $1"
}

log_error() {
    echo "[$(date '+%H:%M:%S')] ERROR: $1" >&2
}
