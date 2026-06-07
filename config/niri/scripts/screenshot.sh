#!/bin/bash

ts=$(date +%Y-%m-%d_%H-%M-%S)
file="/tmp/shot-$ts.png"

grim -g "$(slurp)" "$file" &&
wl-copy < "$file" &&
notify-send "Screenshot salva" "$file"