#!/usr/bin/env sh

device=$(wpctl inspect @DEFAULT_SOURCE@)

if [[ $device == *"Burr-Brown"* ]]; then
    wpctl set-mute @DEFAULT_SOURCE@ toggle
fi
