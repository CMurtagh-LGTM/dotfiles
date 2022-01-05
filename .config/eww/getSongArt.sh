#!/bin/bash

# https://github.com/TheRealKizu/dotfiles/blob/bspwm/cfg/eww/scripts/getSongArt

tmp_dir="/tmp/spotify"
album=$(playerctl metadata --format '{{ album }}')
# Remove spaces
album=${album// /_}
tmp_cover_path=$tmp_dir/$album.png

if [ ! -d $tmp_dir ]; then
	mkdir -p $tmp_dir
fi

if [ ! -f $tmp_cover_path ]; then
	artlink="$(playerctl metadata mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g')"
	
	if [ $(playerctl metadata mpris:artUrl) ]; then
		curl -s "$artlink" --output $tmp_cover_path
		convert $tmp_cover_path -resize 160x160 $tmp_cover_path
	else
		cp $HOME/.config/eww/spoop.png $tmp_cover_path
	fi
fi
