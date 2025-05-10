#!/usr/bin/env bash

# Get list of outputs from Sway
active_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name')
inactive_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == false) | .name')
all_outputs=$(swaymsg -t get_outputs | jq -r '.[] | .name')
dmenu_cmd="wofi --dmenu"

while true; do
  # Display the list of outputs in wofi (dmenu mode)
  chosen_output=$(echo "$all_outputs" | $dmenu_cmd --prompt="Choose a monitor: ")

  if [ -z "$chosen_output" ]; then
    # Handle case where user doesn't select anything (e.g., closes wofi)
    break
  fi

  if echo "${active_outputs}" | grep -q "${chosen_output}"; then
    msg="Disable ${chosen_output}?"
    # Confirmation dialog
    confirmation=$(echo -e "${msg}\nUpdate Resolution\nBack\nCancel" | $dmenu_cmd --prompt="${chosen_output} is Active: ")
  elif echo "${inactive_outputs}" | grep -q "${chosen_output}"; then
    msg="Enable ${chosen_output}?"
    confirmation=$(echo -e "${msg}\nBack\nCancel" | $dmenu_cmd --prompt="${chosen_output} is Inactive: ")
  else
    echo "Monitor Status of ${chosen_output} is Unknown"
    exit 0
  fi

  if [ -n "${chosen_output}" ]; then
    case "${confirmation}" in
    "${msg}")
      swaymsg output "${chosen_output}" toggle
      break
      ;;
    "Update Resolution")
      resolutions=$(
        swaymsg -t get_outputs | jq -r \
          ".[] | select(.name == \"${chosen_output}\") | .modes | map(\"\(.width)x\(.height)@\(.refresh/1000)\") | join(\"\n\")"
      )
      current_res=$(
        swaymsg -t get_outputs | jq -r \
          ".[] | select(.name == \"${chosen_output}\") | .current_mode | \"\(.width)x\(.height)@\(.refresh/1000)\""
      )
      chosen_resolution=$(echo "${resolutions}" | $dmenu_cmd --prompt="Current Resolution is: ${current_res}")

      if [ -n "${chosen_resolution}" ]; then
        # Set the chosen resolution
        swaymsg output "${chosen_output}" mode "${chosen_resolution}Hz"
      fi
      break
      ;;
    "Cancel")
      break
      ;;
    "")
      # Handle case where user doesn't select anything (e.g., closes wofi)
      break
      ;;
    esac
  fi
done
exit 0
