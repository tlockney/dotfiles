#!/bin/bash
# =============================================================================
# Mode 3: SPLIT (MBP / Mini)
# =============================================================================
# Dell = MBP (Thunderbolt)
# BenQ = Mini (HDMI 2 via USB-C adapter)
# 
# Use case: Work on primary + glanceable personal desktop on secondary
# =============================================================================

source "$(dirname "$0")/helpers.sh"

log_info "Switching to SPLIT mode (Dell → MBP, BenQ → Mini)"

# Validate config
if [[ -z "$DELL_TB" || -z "$BENQ_HDMI2" ]]; then
    log_error "Missing DDC values in config.sh. Run discovery first."
    exit 1
fi

# Step 1: Configure Mini - only BenQ connected, Dell disconnected
if is_host_reachable "$MINI_HOST"; then
    log_info "Configuring Mini: BenQ connected, Dell disconnected..."
    disconnect_display_remote "$MINI_HOST" "$DELL_NAME"
    connect_display_remote "$MINI_HOST" "$BENQ_NAME"
fi

# Step 2: Configure MBP - only Dell connected, BenQ disconnected
if is_host_reachable "$MBP_HOST"; then
    log_info "Configuring MBP: Dell connected, BenQ disconnected..."
    connect_display_remote "$MBP_HOST" "$DELL_NAME"
    disconnect_display_remote "$MBP_HOST" "$BENQ_NAME"
fi

# Step 3: Switch monitor inputs
log_info "Switching Dell to Thunderbolt input..."
switch_dell_local "$DELL_TB"
sleep 0.5

log_info "Switching BenQ to HDMI 2..."
switch_benq_local "$BENQ_HDMI2"

log_info "SPLIT (MBP/Mini) mode active"
