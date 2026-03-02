#!/bin/bash

# Get random color from hostname MD5 hash
COLOR_NUM=$((0x$(hostname | md5sum | cut -c1-2)))

echo "Color number: $COLOR_NUM" >&2

# Set background color
tmux set-option -g status-bg colour$COLOR_NUM

# Determine text color based on luminance
TEXT_COLOR='white'  # default

if [ $COLOR_NUM -lt 16 ]; then
  # Standard colors (0-15)
  if [ $COLOR_NUM -lt 8 ]; then
    # Dark standard colors
    TEXT_COLOR='white'
  else
    # Bright standard colors
    TEXT_COLOR='black'
  fi
  echo "Standard color: $COLOR_NUM, text: $TEXT_COLOR" >&2
else
  # Calculate RGB from 256-color palette
  if [ $COLOR_NUM -lt 232 ]; then
    # 216-color cube (colors 16-231)
    IDX=$((COLOR_NUM - 16))
    R=$((IDX / 36 * 51))
    G=$(((IDX % 36) / 6 * 51))
    B=$((IDX % 6 * 51))
  else
    # Grayscale (colors 232-255)
    GRAY=$(((COLOR_NUM - 232) * 10 + 8))
    R=$GRAY
    G=$GRAY
    B=$GRAY
  fi

  echo "RGB: R=$R, G=$G, B=$B" >&2

  # Calculate perceived luminance using standard formula
  LUMINANCE=$((299 * R / 1000 + 587 * G / 1000 + 114 * B / 1000))
  echo "Luminance: $LUMINANCE" >&2

  if [ $LUMINANCE -lt 128 ]; then
    TEXT_COLOR='white'
  else
    TEXT_COLOR='black'
  fi
fi

echo "Setting text color: $TEXT_COLOR" >&2
tmux set-option -g status-fg $TEXT_COLOR
