#!/bin/bash
tmux new-session -d -n foo
tmux new-window -n bar
tmux -2 attach-session -d
