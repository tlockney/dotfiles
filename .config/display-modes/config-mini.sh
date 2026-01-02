#!/bin/bash
# Display Mode Configuration - Mac Mini
# Run discover.sh to find your DDC input values, then fill in below.

# =============================================================================
# HOSTNAMES / IPs
# =============================================================================
MINI_HOST="macmini.local"
MBP_HOST="mbp.local"

# =============================================================================
# DDC INPUT VALUES
# =============================================================================
# Discover these values by:
#   1. Manually switch monitor to desired input
#   2. Run: betterdisplaycli get -nameLike=dell -ddc -vcp=inputSelect -value
#   3. Record the decimal value below

# Dell U4025QW inputs
DELL_TB=""        # Thunderbolt/USB-C input (for MBP)
DELL_HDMI=""      # HDMI input (for Mini)

# BenQ MA320U inputs
BENQ_HDMI1=""     # HDMI 1 (for MBP)
BENQ_HDMI2=""     # HDMI 2 (for Mini via USB-C adapter)
BENQ_USBC=""      # USB-C 90W port (for Air)

# =============================================================================
# USB SWITCH (for display-switch integration)
# =============================================================================
# Facecam Pro USB ID (format: VID:PID, e.g., 0fd9:0084)
FACECAM_USB_ID=""
