#!/usr/bin/env bash

A_1080=400
B_1080=400

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Get resolution and scaling factor of the focused monitor
resolution=$(swaymsg -t get_outputs | jq '.[] | select(.focused==true) | .current_mode.height')
scale=$(swaymsg -t get_outputs | jq '.[] | select(.focused==true) | .scale')

# Calculate the top and bottom margins for wlogout
top_margin=$(($A_1080 * 1080 / $resolution))
bottom_margin=$(($B_1080 * 1080 / $resolution))

# Start wlogout with calculated margins and Wayland protocol
wlogout -b 4 -T $top_margin -B $bottom_margin &
