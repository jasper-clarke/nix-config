if [[ $(playerctl -l) == *"firefox"* ]]; then
	if [[ $(hyprctl clients) == *"YouTube"* ]]; then
		playerctl --player=firefox play-pause
		echo "Firefox > Element > Firefox"
	else
		if [[ $(mpc status) == *"[playing]"* || $(mpc status) == *"[paused]"* ]]; then
			if [[ $(hyprctl activewindow | grep -E "initialClass: ") == *"firefox"* ]]; then
				playerctl --player=firefox play-pause
				echo "Firefox > MPD > Firefox"
			else
				mpc toggle
				echo "Firefox > MPD"
			fi
		else
			playerctl --player=firefox play-pause
			echo "Firefox > Firefox"
		fi
	fi
else
	mpc toggle
	echo "MPD"
fi
