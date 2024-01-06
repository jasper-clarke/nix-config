#!/bin/sh

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='style'

# CMDs
uptime=`uptime | awk '{ print $3 }' | sed 's/:/ hours /g' | sed 's/,/ minutes/g'`

# Options
shutdown=''
reboot=''
logout=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye $USER" \
		-mesg "Uptime: $uptime" \
		-theme ~/.config/rofi/powermenu.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		shutdown now
        ;;
    $reboot)
		reboot
        ;;
    $logout)
		awesome-client 'awesome.quit()'
        ;;
esac
