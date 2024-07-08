#!/bin/bash
monitor_setup() {
	monitor_count=$(xrandr --query | grep " connected" | grep -v "disconnected" | wc -l)

	single_monitor_script="$HOME/.config/scripts/screenlayout_single_monitor.sh"
	multi_monitor_script="$HOME/.config/scripts/screenlayout_triple_monitor.sh"

	case $monitor_count in
	1)
		echo "Single monitor detected"
		$single_monitor_script
		;;
	3)
		echo "Three monitors detected"
		$multi_monitor_script
		;;
	*)
		echo "Unexpected number of monitors: $monitor_count"
		;;
	esac
}

monitor_setup

udevadm monitor --kernel --subsystem-match=drm | while read -r line; do
	if echo "$line" | grep -q "change"; then
		sleep 2
		monitor_setup
	fi
done
