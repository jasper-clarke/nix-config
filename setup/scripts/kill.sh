#!/bin/sh
winID=$(xdotool getactivewindow)
winClass=$(xprop -id $winID WM_CLASS)
if [[ $winClass = *"Steam"* ]]; then
    xdotool windowunmap $(xdotool getactivewindow)
    exit
elif [[ $winClass = *"steamwebhelper"* ]]; then
    exit
elif [[ $winClass = *"Spotify"* ]]; then
    spotify-tray --toggle
    exit
else
    xdotool getwindowfocus windowquit
    exit;
fi
