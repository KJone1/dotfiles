#!/usr/bin/env bash

has_multiple_displays() {
  result=$(swaymsg -t get_outputs | jq '. | length > 1')
  [[ "$result" == "true" ]]
}

if has_multiple_displays; then
  o=$(swaymsg -t get_outputs | jq  -r '. | map(.name) | join(", ")')
  text="{\"text\":\"\",\"tooltip\":\""$o"\"}"
  echo $text
fi
