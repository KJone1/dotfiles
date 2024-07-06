#! /usr/bin/env bash

set -eo pipefail

has_multiple_displays() {
  result=$(swaymsg -t get_outputs | jq '. | length > 1')
  [[ "$result" == "true" ]]
}

laptop_display=$(swaymsg -t get_outputs | jq -r '[.[] | select(.name | test("eDP"; "i")) | .name] | join("\n")')

if has_multiple_displays; then
  echo "Toggling output: ${laptop_display}"
  swaymsg output "${laptop_display}" toggle
else
  echo "No external display connected. No toggling needed."
fi
