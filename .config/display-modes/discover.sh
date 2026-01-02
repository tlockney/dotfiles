#!/bin/bash
# =============================================================================
# Display Discovery Script
# =============================================================================
# Run this script to discover DDC input values for your monitors.
# You'll need to manually switch inputs on each monitor and run the
# corresponding read command to discover each value.
# =============================================================================

echo "========================================"
echo "Display Mode Discovery"
echo "========================================"
echo ""

# Check if betterdisplaycli is installed
if ! command -v betterdisplaycli &> /dev/null; then
    echo "ERROR: betterdisplaycli not found"
    echo "Install with: brew install waydabber/betterdisplay/betterdisplaycli"
    exit 1
fi

echo "Step 1: Finding connected displays..."
echo "----------------------------------------"
betterdisplaycli get -identifiers 2>/dev/null | head -20
echo ""

echo "Step 2: DDC Capabilities"
echo "----------------------------------------"
echo "Dell monitor capabilities:"
betterdisplaycli get -nameLike=dell -ddcCapabilities 2>/dev/null || echo "  (Dell not found or DDC not available)"
echo ""
echo "BenQ monitor capabilities:"
betterdisplaycli get -nameLike=benq -ddcCapabilities 2>/dev/null || echo "  (BenQ not found or DDC not available)"
echo ""

echo "Step 3: Current Input Values"
echo "----------------------------------------"
echo "To discover input values, manually switch each monitor to the desired"
echo "input using the monitor's controls, then run the read command below."
echo ""
echo "Dell - current input value:"
betterdisplaycli get -nameLike=dell -ddc -vcp=inputSelect -value 2>/dev/null || echo "  (not available)"
echo ""
echo "BenQ - current input value:"
betterdisplaycli get -nameLike=benq -ddc -vcp=inputSelect -value 2>/dev/null || echo "  (not available)"
echo ""

echo "========================================"
echo "INSTRUCTIONS"
echo "========================================"
echo ""
echo "1. Switch Dell to Thunderbolt input (for MBP), run:"
echo "   betterdisplaycli get -nameLike=dell -ddc -vcp=inputSelect -value"
echo "   Record this as DELL_TB in config.sh"
echo ""
echo "2. Switch Dell to HDMI input (for Mini), run:"
echo "   betterdisplaycli get -nameLike=dell -ddc -vcp=inputSelect -value"
echo "   Record this as DELL_HDMI in config.sh"
echo ""
echo "3. Switch BenQ to HDMI 1 (for MBP), run:"
echo "   betterdisplaycli get -nameLike=benq -ddc -vcp=inputSelect -value"
echo "   Record this as BENQ_HDMI1 in config.sh"
echo ""
echo "4. Switch BenQ to HDMI 2 (for Mini adapter), run:"
echo "   betterdisplaycli get -nameLike=benq -ddc -vcp=inputSelect -value"
echo "   Record this as BENQ_HDMI2 in config.sh"
echo ""
echo "5. Switch BenQ to USB-C (for Air), run:"
echo "   betterdisplaycli get -nameLike=benq -ddc -vcp=inputSelect -value"
echo "   Record this as BENQ_USBC in config.sh"
echo ""

echo "========================================"
echo "USB Device Discovery (for display-switch)"
echo "========================================"
echo ""
echo "Facecam Pro USB ID:"
system_profiler SPUSBDataType 2>/dev/null | grep -A8 "Facecam Pro" || echo "  (Facecam Pro not connected)"
echo ""
echo "Look for 'Vendor ID' and 'Product ID' above."
echo "Format for config: 0fd9:XXXX (where XXXX is the product ID)"
