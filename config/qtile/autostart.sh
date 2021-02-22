#!/bin/sh
feh --bg-fill /home/indigo/Pictures/mon.png &
picom -b
setxkbmap -model abnt2 -layout br &
xrandr --newmode "2560X1080_60.00" 230.00  2560 2720 2992 3424  1080 1083 1093 1120 -hsync +vsync
xransr --addmode HDMI1 2560x1080_60.00
xrandr --output HDMI1 --mode 2560x1080_60.00
# monitor setting cmd sequence:
# cvt 2560 1080 ## resolution we want
# xrandr --newmode "2560x1080_60.00"  230.00  2560 2720 2992 3424  1080 1083 1093 1120 -hsync +vsync  ## output of anterior cmd
# xrandr --addmode HDMI1 2560x1080_60.00
#xrandr --output HDMI1 --mode 2560x1080_60.00
