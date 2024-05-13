
a=$(cd /tmp/hypr/ && ls -rt -I "*.lock" | tail -1)
tail -f /tmp/hypr/$a/hyprland.log
