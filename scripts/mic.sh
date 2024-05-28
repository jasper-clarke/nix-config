device=$(wpctl inspect @DEFAULT_SOURCE@)

vol=$(wpctl get-volume @DEFAULT_SOURCE@)

if [[ $device == *"Audio/Source"* ]]; then
	if [[ $vol == *"MUTED"* ]]; then
		echo "MUTED"
	else
		calc "$vol * 100" | sed -e 's/^[ \t]*//'
	fi
else
	echo "IDLE"
fi
