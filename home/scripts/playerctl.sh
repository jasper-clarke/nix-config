if [[ $(playerctl -l) == *"firefox"* ]]; then
    if [[ $(hyprctl clients) == *"Element"* ]]; then
        if [[ $(mpc status) == *"[playing]"* || $(mpc status) == *"[paused]"* ]]; then
            mpc toggle
            echo "Firefox > Element > MPD"
        else
            playerctl --player=firefox play-pause
            echo "Firefox > Element > Firefox"
        fi
    else
        if [[ $(mpc status) == *"[playing]"* || $(mpc status) == *"[paused]"* ]]; then
            mpc toggle
            echo "Firefox > MPD"
        else
            playerctl --player=firefox play-pause
            echo "Firefox > Firefox"
        fi
    fi
else
    mpc toggle
    echo "MPD"
fi
