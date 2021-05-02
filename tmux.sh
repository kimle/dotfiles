#!/bin/bash
tmux new-session -d -n misc
tmux new-window -n code -c ~/code
tmux -2 attach-session -d
