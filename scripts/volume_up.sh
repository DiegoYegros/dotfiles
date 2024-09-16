#!/bin/bash
DEFAULT_SINK=$(pactl get-default-sink)
pactl set-sink-volume "$DEFAULT_SINK" +5%
VOLUME=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK" | grep "Volume:" | grep -o "[0-9]*%" | head -n 1)
notify-send "Volume: $VOLUME" -r 99192
