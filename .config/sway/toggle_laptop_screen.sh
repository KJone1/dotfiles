#! /usr/bin/env bash

set -eo pipefail

laptop_display=$(swaymsg -t get_outputs | jq -r '[.[] | select(.name | test("HDMI"; "i") | not) | .name] | join("\n")')

echo "Toggling output ${laptop_display}"

swaymsg output "${laptop_display}" toggle

