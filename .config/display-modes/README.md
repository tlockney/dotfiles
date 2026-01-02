# Display Mode Switching Scripts

Automated display switching for multi-Mac desk setup with DDC control and display connection management.

## Overview

These scripts control:
1. **Monitor input switching** via DDC/CI (VCP code 0x60)
2. **Display connection management** via BetterDisplay's `connected` feature

The second part is critical: when a monitor's input is switched away from a Mac, that Mac's display connection should be "disconnected" in BetterDisplay. This prevents macOS from continuing to use a display that's showing a different computer's output.

## Prerequisites

### Software (install on all Macs)

1. **BetterDisplay Pro** - https://betterdisplay.pro
   - Purchase Pro license (required for `connected` feature and CLI)
   - Enable CLI integration: Settings → Application → Integration
   - Enable HTTP integration: Settings → Application → Integration
   - Note the HTTP port (default: 55777)

2. **BetterDisplay CLI**
   ```bash
   brew install waydabber/betterdisplay/betterdisplaycli
   ```

3. **display-switch** (optional, for automatic USB-triggered switching)
   ```bash
   brew install display-switch
   ```

## Installation

1. **Copy scripts to each Mac**
   ```bash
   mkdir -p ~/.config/display-modes
   cp *.sh ~/.config/display-modes/
   chmod +x ~/.config/display-modes/*.sh
   ```

2. **Run discovery to find your DDC values**
   ```bash
   ~/.config/display-modes/discover.sh
   ```
   Follow the prompts to discover input values for each monitor/input combination.

3. **Edit config.sh with your values**
   ```bash
   nano ~/.config/display-modes/config.sh
   ```
   Fill in:
   - Hostnames/IPs for each Mac
   - DDC input values discovered in step 2
   - Facecam Pro USB ID (if using display-switch)

4. **Test scripts manually**
   ```bash
   ~/.config/display-modes/mode-1-work.sh    # Both displays → MBP
   ~/.config/display-modes/mode-4-nonwork.sh # Both displays → Mini
   ```

## Display Modes

| # | Mode | Dell U4025QW | BenQ MA320U | Use Case |
|---|------|--------------|-------------|----------|
| 1 | Work | MBP (Thunderbolt) | MBP (HDMI 1) | Normal work hours |
| 2 | Split (MBP/Air) | MBP (Thunderbolt) | Air (USB-C) | Work + personal laptop |
| 3 | Split (MBP/Mini) | MBP (Thunderbolt) | Mini (HDMI 2) | Work + glanceable personal |
| 4 | Non-work | Mini (HDMI) | Mini (HDMI 2) | Evenings/weekends/freelance |
| 5 | Alt Non-work | Mini (HDMI) | Air (USB-C) | Mini primary + Air secondary |

## Automatic Switching with display-switch

The display-switch utility monitors USB device connections. When the USB switch moves the Facecam Pro between computers, display-switch triggers the corresponding display mode.

### Setup on Mac Mini

1. Copy template and customize:
   ```bash
   cp display-switch-mini.ini.template ~/Library/Preferences/display-switch.ini
   nano ~/Library/Preferences/display-switch.ini
   ```

2. Replace placeholders with your values

3. Start service:
   ```bash
   brew services start display-switch
   ```

### Setup on Work MBP

Same process using `display-switch-mbp.ini.template`.

### Advanced: Full Script Execution

By default, display-switch only switches monitor inputs. To also manage display connections (recommended), uncomment the `on_usb_connect_execute` line and point it to the full mode script.

## Stream Deck Integration

### Option A: Local Script Execution
If Stream Deck is connected to the same Mac running the script:
1. Add a "System → Open" action
2. Set path to script, e.g., `~/.config/display-modes/mode-1-work.sh`

### Option B: HTTP API (Remote)
If Stream Deck is on a different machine, use curl:
```bash
# Example: Switch Dell to HDMI input on Mini
curl "http://macmini.local:55777/set?nameLike=dell&ddc&vcp=0x60&value=17"
```

Or use the "Website" action to call the script via HTTP.

## How Display Connection Management Works

BetterDisplay's `connected` feature is key to this setup:

- **connected=on**: macOS sees the display and uses it normally
- **connected=off**: macOS "forgets" the display, removes it from display layout

When you switch Mode 1 → Mode 4:
1. Script disconnects Dell and BenQ from MBP's perspective
2. Script switches monitor inputs to Mini sources
3. Script connects Dell and BenQ from Mini's perspective

This prevents issues like:
- Windows appearing on a display you can't see
- GPU rendering to an invisible display
- Display arrangement confusion

## Troubleshooting

### DDC commands not working
- Ensure DDC/CI is enabled in monitor OSD settings
- Some cables/adapters don't pass DDC; try different cable
- USB-C to HDMI adapters are sometimes problematic for DDC

### Display won't reconnect
- Run: `betterdisplaycli set -nameLike=dell -connected=on`
- Check BetterDisplay app for any errors
- Restart BetterDisplay if needed

### HTTP API not responding
- Verify HTTP integration is enabled in BetterDisplay settings
- Check firewall isn't blocking port 55777
- Test with: `curl http://localhost:55777/get?proAvailable`

### display-switch not triggering
- Verify USB ID matches exactly (case-sensitive hex)
- Check service status: `brew services list`
- Check logs: `log show --predicate 'process == "display-switch"' --last 5m`

## File Reference

```
~/.config/display-modes/
├── config.sh                    # Your DDC values and hostnames
├── helpers.sh                   # Shared functions
├── discover.sh                  # DDC value discovery utility
├── mode-1-work.sh              # Both displays → MBP
├── mode-2-split-air.sh         # Dell → MBP, BenQ → Air
├── mode-3-split-mini.sh        # Dell → MBP, BenQ → Mini
├── mode-4-nonwork.sh           # Both displays → Mini
├── mode-5-nonwork-air.sh       # Dell → Mini, BenQ → Air
├── display-switch-mini.ini.template
└── display-switch-mbp.ini.template

~/Library/Preferences/
└── display-switch.ini           # display-switch config (per machine)
```
