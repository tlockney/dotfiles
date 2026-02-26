#!/bin/bash

# Create a meeting note and open it in Obsidian
# Delegates to mtg for note creation

set -euo pipefail

~/bin/mtg create --uid "$1"
