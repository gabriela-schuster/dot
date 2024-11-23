#!/usr/bin/env bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolumenotification"

# Query pulseaudio for the current volume and whether or not the speaker is muted
volume="$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | awk '{print $5}' | sed 's/[^0-9]*//g')"
mute="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"

if [[ $volume == 0 || "$mute" == "yes" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted" ""
else
    # Show the volume notification
	bar=$(seq -s "─" $(($volume / 3)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -a "changeVolume" \
         -u low \
         -i audio-volume-muted-blocking \
         -h string:x-dunst-stack-tag:$msgTag \
         -u normal \
         "Volume: ${volume}%" \
         " $bar"
		#  -h int:value:${volume} \
fi

canberra-gtk-play -i audio-volume-change -d "changeVolume"
