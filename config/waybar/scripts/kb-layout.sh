#!/bin/bash

layouts=("us" "us(colemak)")

current=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap')

if [[ "$1" == "toggle" ]]; then
  if [[ "$current" == *"Colemak"* ]]; then
    hyprctl keyword input:kb_variant ""
  else
    hyprctl keyword input:kb_variant colemak
  fi
  exit
fi

if [[ "$current" == *"Colemak"* ]]; then
  echo "Colemak"
else
  echo "Qwerty"
fi