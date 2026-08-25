#!/bin/bash

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
mute=$(echo $volume | grep -oE '\[MUTED\]')
level=$(echo $volume | awk '{print int($2 * 100)}')

if [ "$mute" != "" ]; then
    icon=""
else
    if [ "$level" -lt 30 ]; then
        icon="󰖀"
    elif [ "$level" -gt 100 ]; then
        icon="󱄡"
    else
        icon="󰕾"
    fi
fi

echo "<span color='#7aa2f7'>$icon</span> $level%"

