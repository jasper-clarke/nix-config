

ls ~/.wallpapers |sort -R |tail -$N |while read file; do
    swww img ~/.wallpapers/$file \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type "grow" \
    --transition-duration 0.7 \
    --transition-fps 60 \
    --invert-y \
    --transition-pos "$( hyprctl cursorpos )"

done
