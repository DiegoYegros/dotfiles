#!/bin/bash
pactl -- set-sink-volume 0 -5% && notify-send "volume: "$(pactl list sinks | grep -i "^\s*Volume" | tail -1 | grep "[0-9]\+%" -o | head -1)"" -r 99192 #i
