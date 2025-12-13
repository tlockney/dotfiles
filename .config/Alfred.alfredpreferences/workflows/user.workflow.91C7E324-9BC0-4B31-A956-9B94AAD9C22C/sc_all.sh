#!/bin/zsh

# Get an alphabetic list of all shortcuts
strsclist=$(shortcuts list|sort -f)

# Escape double quotes
strsclist=${strsclist//\"/\\\"}

# Build the basic JSON content
jsonsclist="$(echo $strsclist | sed -r 's/(.*)/{"title" : "\1", "arg" : "\1"},/')REMOVELASTCOMMA"
# Strip the last comma (and the end of list marker)
jsonsclist=$(echo $jsonsclist | sed -r 's/,REMOVELASTCOMMA//')

# Output the JSON
echo {\"items\": [
echo $jsonsclist
echo "]}"
