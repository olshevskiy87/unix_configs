#!/usr/bin/env bash

msg=$(cmus-remote -Q | grep ^stream | cut -d ' ' -f2-)

#notify-send "$msg" &
tmux set-option -t cmus set-titles-string "$msg"
