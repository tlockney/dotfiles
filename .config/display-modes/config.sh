#!/bin/bash
# Display Mode Switching Configuration
# This file auto-detects the current machine and sources the appropriate config.
#
# Machine-specific config files contain:
#   - Hostnames for remote HTTP API calls
#   - DDC input values (discovered per-machine using discover.sh)
#   - USB device IDs (for display-switch integration)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# MACHINE DETECTION
# =============================================================================
_detect_machine() {
    local hostname
    hostname=$(hostname -s | tr '[:upper:]' '[:lower:]')
    case "$hostname" in
        *mini*)     echo "mini" ;;
        *mbp*|*macbookpro*) echo "mbp" ;;
        *air*|*mba*)        echo "air" ;;
        *)          echo "unknown" ;;
    esac
}

CURRENT_MACHINE="$(_detect_machine)"

# =============================================================================
# LOAD MACHINE-SPECIFIC CONFIG
# =============================================================================
MACHINE_CONFIG="$SCRIPT_DIR/config-${CURRENT_MACHINE}.sh"

if [[ -f "$MACHINE_CONFIG" ]]; then
    source "$MACHINE_CONFIG"
else
    echo "WARNING: No config found for machine '$CURRENT_MACHINE'" >&2
    echo "Expected: $MACHINE_CONFIG" >&2
    echo "Run discover.sh to find DDC values, then create the config file." >&2
fi

# =============================================================================
# SHARED CONFIGURATION
# =============================================================================
# BetterDisplay HTTP port (default: 55777)
BD_PORT="${BD_PORT:-55777}"

# Display name patterns for BetterDisplay queries (case-insensitive partial match)
DELL_NAME="${DELL_NAME:-dell}"
BENQ_NAME="${BENQ_NAME:-benq}"
