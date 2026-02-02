#!/bin/bash
# =============================================================================
# Mode 4: NON-WORK
# =============================================================================
# Dell = Mini (HDMI)
# BenQ = Mini (HDMI 2 via USB-C adapter)
# 
# Use case: Evenings/weekends, freelance work, both displays driven by Mac Mini
# =============================================================================

source "$(dirname "$0")/helpers.sh"

log_info "Switching to NON-WORK mode (both displays → Mini)"

# Validate config
if [[ -z "$DELL_HDMI" || -z "$BENQ_HDMI2" ]]; then
    log_error "Missing DDC values in config.sh. Run discovery first."
    exit 1
fi

# Step 1: Disconnect displays from MBP (so macOS MBP stops using them)
if is_host_reachable "$MBP_HOST"; then
    log_info "Disconnecting displays from MBP..."
    disconnect_both_remote "$MBP_HOST"
else
    log_info "MBP not reachable, skipping disconnect"
fi

# Step 2: Switch monitor inputs to Mini sources
log_info "Switching Dell to HDMI input..."
switch_dell_local "$DELL_HDMI"
sleep 0.5

log_info "Switching BenQ to HDMI 2..."
switch_benq_local "$BENQ_HDMI2"

# Step 3: Connect displays on Mini (in case they were disconnected)
current_machine=$(get_current_machine)
if [[ "$current_machine" == "mini" ]]; then
    log_info "Connecting displays locally on Mini..."
    connect_both_local
elif is_host_reachable "$MINI_HOST"; then
    log_info "Connecting displays on Mini via HTTP..."
    connect_both_remote "$MINI_HOST"
fi

log_info "NON-WORK mode active"
