# monitor=$(hyprctl activewindow | grep -E "monitor: " | sed -e 's/^[ \t]*//')
# if [[ $monitor == *"1"* ]]; then
#     hyprctl dispatch workspace $1
# elif [[ $monitor == *"0"* ]]; then
#     calc=$(calc "$1 + 3" | sed -e 's/^[ \t]*//' )
#     hyprctl dispatch workspace "$calc"
# fi

monitor=$(hyprctl activeworkspace | grep -E "monitorID: " | sed -e 's/^[ \t]*//')
if [[ $monitor == *"1"* ]]; then
    hyprctl dispatch workspace $1
elif [[ $monitor == *"0"* ]]; then
    calc=$(calc "$1 + 3" | sed -e 's/^[ \t]*//' )
    hyprctl dispatch workspace "$calc"
fi