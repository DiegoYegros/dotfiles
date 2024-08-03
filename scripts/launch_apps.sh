#!/bin/sh

WS1="1"
WS2="2"
WS3="3"

# Function to run a command in a specific workspace
run_in_workspace() {
	local ws=$1
	local command=$2
	i3-msg "workspace $ws; exec $command"
}

# WS1
run_in_workspace "$WS1" "slack"

# WS2
run_in_workspace "$WS2" "brave"

# WS3
run_in_workspace "$WS3" "intellij-idea-ultimate"
run_in_workspace "$WS3" "alacritty"

i3-msg "workspace $WS2"
