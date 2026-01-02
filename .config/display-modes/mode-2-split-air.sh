#!/bin/bash
# =============================================================================
# Mode 2: SPLIT (MBP / Air)
# =============================================================================
# Dell = MBP (Thunderbolt)
# BenQ = Air (USB-C)
# 
# Use case: Work on primary display + personal laptop for research/reference
# =============================================================================

source "$(dirname "$0")/helpers.sh"

log_info "Switching to SPLIT mode (Dell → MBP, BenQ → Air)"

# Validate config
if [[ -z "$DELL_TB" || -z "$BENQ_USBC" ]]; then
    log_error "Missing DDC values in config.sh. Run discovery first."
    exit 1
fi

# Step 1: Disconnect BenQ from Mini (Dell stays disconnected too)
if is_host_reachable "$MINI_HOST"; then
    log_info "Disconnecting displays from Mini..."
    disconnect_both_remote "$MINI_HOST"
fi

# Step 2: On MBP, disconnect BenQ but keep Dell connected
# (MBP only drives Dell in this mode)
if is_host_reachable "$MBP_HOST"; then
    log_info "Configuring MBP: Dell connected, BenQ disconnected..."
    connect_display_remote "$MBP_HOST" "$DELL_NAME"
    disconnect_display_remote "$MBP_HOST" "$BENQ_NAME"
fi

# Step 3: Switch monitor inputs
log_info "Switching Dell to Thunderbolt input..."
switch_dell_local "$DELL_TB"
sleep 0.5

log_info "Switching BenQ to USB-C input..."
switch_benq_local "$BENQ_USBC"

# Note: Air's BenQ connection is managed by Air itself via USB-C
# The Air should have BenQ connected when plugged in

log_info "SPLIT (MBP/Air) mode active"
