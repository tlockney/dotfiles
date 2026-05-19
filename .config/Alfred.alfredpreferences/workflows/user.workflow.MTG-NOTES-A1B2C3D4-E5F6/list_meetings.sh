#!/bin/bash

# List today's meetings as Alfred JSON
# Delegates to mtg for calendar data

set -euo pipefail

# Ensure tools installed via mise are available in Alfred's minimal environment
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

QUERY="${1:-}"

# mtg --alfred parses the query for a leading date token (+N, -N, YYYY-MM-DD)
# and emits day-navigation items at the top of the list. Treats the rest as
# a meeting-title filter.
#
# -q="..." (rather than -q "...") is required so queries starting with `-`
# (e.g. "-1") aren't misread as a flag by parseArgs.
~/bin/mtg list --json --alfred -q="$QUERY"
