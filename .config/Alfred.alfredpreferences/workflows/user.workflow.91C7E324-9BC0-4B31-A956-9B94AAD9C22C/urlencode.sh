#!/bin/zsh
echo -n "${@}" | perl -MURI::Escape -ne 'chomp;print uri_escape($_),""'