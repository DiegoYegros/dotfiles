#!/bin/bash
VPN_CONFIG="/home/alezkar/Downloads/vpnfile.ovpn"
VPN_CONTROL_FILE="/tmp/vpn_connected"

if [ ! -f "$VPN_CONTROL_FILE" ]; then
	echo "Starting VPN..."
	openvpn --config "$VPN_CONFIG" &
	echo $! >"$VPN_CONTROL_FILE"
else
	echo "Stopping VPN..."
	if [ -s "$VPN_CONTROL_FILE" ]; then
		VPN_PID=$(cat "$VPN_CONTROL_FILE")
		kill "$VPN_PID"
	fi
	rm "$VPN_CONTROL_FILE"
fi
