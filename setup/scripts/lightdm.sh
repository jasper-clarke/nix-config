xrandr --output DP-2 --mode 2560x1440 --rate 120.00 --primary --output DP-0 --mode 1920x1080 --rate 120.00 --right-of DP-2 --rotate right

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
	   eval $(dbus-launch --sh-syntax --exit-with-session)
fi
