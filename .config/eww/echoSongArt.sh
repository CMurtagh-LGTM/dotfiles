#!/bin/bash

# https://github.com/TheRealKizu/dotfiles/blob/bspwm/cfg/eww/scripts/echoSongArt

album=$(playerctl metadata --format '{{ album }}')
# Remove spaces
album=${album// /_}

echo "/tmp/leftwm/spotify/${album}.png"
