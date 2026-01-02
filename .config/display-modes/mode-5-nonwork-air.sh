#!/bin/bash
# =============================================================================
# Mode 5: ALT NON-WORK (Mini / Air)
# =============================================================================
# Dell = Mini (HDMI)
# BenQ = Air (USB-C)
# 
# Use case: Personal time with Mini on primary + Air on secondary
# =============================================================================

source "$(dirname "$0")/helpers.sh"

log_info "Switching to ALT NON-WORK mode (Dell → Mini, BenQ → Air)"

# Validate config
if [[ -z "$DELL_HDMI" || -z "$BENQ_USBC" ]]; then
    log_error "Missing DDC values in config.sh. Run discovery first."
    exit 1
fi

# Step 1: Disconnect both displays from MBP
if is_host_reachable "$MBP_HOST"; then
    log_info "Disconnecting displays from MBP..."
    disconnect_both_remote "$MBP_HOST"
fi

# Step 2: Configure Mini - only Dell connected, BenQ disconnected
if is_host_reachable "$MINI_HOST"; then
    log_info "Configuring Mini: Dell connected, BenQ disconnected..."
    connect_display_remote "$MINI_HOST" "$DELL_NAME"
    disconnect_display_remote "$MINI_HOST" "$BENQ_NAME"
fi

# Step 3: Switch monitor inputs
log_info "Switching Dell to HDMI input..."
switch_dell_local "$DELL_HDMI"
sleep 0.5

log_info "Switching BenQ to USB-C input..."
switch_benq_local "$BENQ_USBC"

# Note: Air's BenQ connection is managed by Air itself

log_info "ALT NON-WORK (Mini/Air) mode active"
