vol=$(wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2 }')

status=$(wpctl get-volume @DEFAULT_SINK@)

if [[ $status == *"MUTED"* ]]; then
    echo "MUTED"
else
    calc "$vol * 100" | sed -e 's/^[ \t]*//'
fi
