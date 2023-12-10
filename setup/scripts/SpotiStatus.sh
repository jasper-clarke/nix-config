#!/bin/sh
pctl=$(playerctl --player=spotify status)
if  [[ $pctl = *"Playing"* ]]; then
    playerctl --player=spotify metadata title
elif [[ $pctl = *"Paused"* ]]; then
    echo "Paused"
else
    echo ""
fi
