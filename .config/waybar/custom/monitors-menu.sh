#!/usr/bin/env bash

# Get list of outputs from Sway
active_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name')
inactive_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == false) | .name')
all_outputs=$(swaymsg -t get_outputs | jq -r '.[] | .name')

while true; do
  # Display the list of outputs in wofi (dmenu mode)
  chosen_output=$(echo "$all_outputs" | wofi --dmenu --prompt="Choose a monitor:")

  if [ -z "$chosen_output" ]; then
    # Handle case where user doesn't select anything (e.g., closes wofi)
    break
  fi

  if echo "$active_outputs" | grep -q "$chosen_output"; then
    status="Active"
    msg="Disable ${chosen_output}?"
  elif echo "$inactive_outputs" | grep -q "$chosen_output"; then
    status="Inactive"
    msg="Enable ${chosen_output}?"
  else
    echo "Monitor Status of $chosen_output is Unknown"
    exit 0
  fi

  if [ -n "$chosen_output" ]; then
      # Confirmation dialog
      confirmation=$(echo -e "${msg}\nBack\nCancel" | wofi --dmenu --prompt="${chosen_output} is ${status}: ")

      if [ "$confirmation" = "${msg}" ]; then
        swaymsg output "${chosen_output}" toggle
        break
      elif [ "$confirmation" = "Cancel" ]; then
        break;
      elif [ -z "$confirmation" ]; then
        # Handle case where user doesn't select anything (e.g., closes wofi)
        break
      fi
  fi
done
exit 0
