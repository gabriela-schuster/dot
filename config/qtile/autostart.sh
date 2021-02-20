#!/bin/sh
feh --bg-fill /home/indigo/Pictures/mon.png &
picom -b
setxkbmap -model abnt2 -layout br &
%(xrandr)s &
xrandr --output HDMI1 --mode 2560x1080_60.00
