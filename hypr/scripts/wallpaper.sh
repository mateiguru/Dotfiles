#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Error: No wallpaper image provided."
    exit 1
else
    wallpaper=$1
fi

# Ensure the wallpaper path is quoted correctly
used_wallpaper="$wallpaper"
echo ":: Setting wallpaper with original image $used_wallpaper"

# Apply the pywal colors based on the wallpaper
echo ":: Execute pywal with $used_wallpaper"
wal -q -i "$used_wallpaper"

#wpg -s "$used_wallpaper" --noreload --noterminal

# Source the generated color scheme
source "$HOME/.cache/wal/colors.sh"

# Reset Waybar to reflect changes (assuming you have a way to trigger the update)
~/.config/hypr/scripts/waybar_reset.sh

# Use swww to set the wallpaper
swww img "$used_wallpaper"

# Set firefox color scheme
sudo pywalfox update

