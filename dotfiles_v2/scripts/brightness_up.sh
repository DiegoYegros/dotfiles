#!/bin/bash
brightnessctl set 5%+ && notify-send "brightness: "$(brightnessctl | grep "[0-9]\\+%" -o)"" -r 99191
