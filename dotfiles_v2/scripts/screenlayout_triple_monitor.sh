#!/bin/bash
xrandr --output eDP-1 --primary --mode 1920x1080 --pos 1366x0 --rotate normal --output DP-1 --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-1-0 --mode 1920x1080 --rate 120 --pos 3286x0 --rotate normal
./fehbg.sh
