#!/bin/bash
# =============================================================================
# Mode 1: WORK
# =============================================================================
# Dell = MBP (Thunderbolt)
# BenQ = MBP (HDMI 1)
# 
# Use case: Normal work hours, both displays driven by Work MBP
# =============================================================================

source "$(dirname "$0")/helpers.sh"

log_info "Switching to WORK mode (both displays → MBP)"

# Validate config
if [[ -z "$DELL_TB" || -z "$BENQ_HDMI1" ]]; then
    log_error "Missing DDC values in config.sh. Run discovery first."
    exit 1
fi

# Step 1: Disconnect displays from Mini (so macOS Mini stops using them)
if is_host_reachable "$MINI_HOST"; then
    log_info "Disconnecting displays from Mini..."
    disconnect_both_remote "$MINI_HOST"
else
    log_info "Mini not reachable, skipping disconnect"
fi

# Step 2: Switch monitor inputs to MBP sources
log_info "Switching Dell to Thunderbolt input..."
switch_dell_local "$DELL_TB"
sleep 0.5

log_info "Switching BenQ to HDMI 1..."
switch_benq_local "$BENQ_HDMI1"

# Step 3: Connect displays on MBP (in case they were disconnected)
# This runs locally assuming the script is executed on MBP
# If running from Mini, we'd need to call MBP via HTTP instead
current_machine=$(get_current_machine)
if [[ "$current_machine" == "mbp" ]]; then
    log_info "Connecting displays locally on MBP..."
    connect_both_local
elif is_host_reachable "$MBP_HOST"; then
    log_info "Connecting displays on MBP via HTTP..."
    connect_both_remote "$MBP_HOST"
fi

log_info "WORK mode active"
