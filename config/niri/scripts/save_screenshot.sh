#!/bin/bash

ts=$(date +%Y-%m-%d_%H-%M-%S)
file="/tmp/shot-$ts.png"

grim -g "$(slurp)" "$file" &&
swappy -f "$file" -o "$file" &&
wl-copy < "$file" &&
notify-send "Screenshot salvo e editado" "$file"