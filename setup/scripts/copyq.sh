#!/usr/bin/env sh

copyq show

sleep 1
while true; do
  # Get the name of the currently focused window
  current_window=$(xdotool getwindowfocus getwindowclassname)

  # Check if the current window is not equal to the target window
  if [[ $current_window != *"copyq"* ]]; then
    # If not equal, run the command to hide copyq
    copyq hide
    break
  fi

  # Adjust the sleep duration based on how frequently you want to check
  sleep 1
done
