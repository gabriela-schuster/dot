#!/bin/sh
nitrogen --restore
#feh --bg-fill /home/indigo/Pictures/astronaut.jpg &
picom -b
setxkbmap -model abnt2 -layout br
xrandr --newmode "2560x1080_60.00"  230.00  2560 2720 2992 3424  1080 1083 1093 1120 -hsync +vsync
xrandr --addmode HDMI1 2560x1080_60.00
xrandr --output HDMI1 --mode 2560x1080_60.00
