if [[ $(playerctl -l) == *"firefox"* ]]; then
    if [[ $(hyprctl clients) == *"Element"* ]]; then
        mpc toggle
    else
        playerctl --player=firefox play-pause
    fi
else
    mpc toggle
fi
