#!/bin/bash

# Open the selected project in VS Code
# Delegates to rproj for the actual opening

set -euo pipefail

# rproj open expects 'host|path' format
~/bin/rproj open "$1"
