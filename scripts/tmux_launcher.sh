#!/bin/bash

# Check if a tmux session exists
if tmux has-session 2>/dev/null; then
	# If a session exists, attach to it
	exec tmux attach
else
	# If no session exists, create one and attach to it
	exec tmux new-session
fi
