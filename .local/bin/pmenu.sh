#!/bin/sh

cat <<EOF | pmenu -r 3| sh &
	gtk-launch thunar
	gtk-launch librewolf
﵁	~/.local/bin/toggle_dash.py

		alacritty -e vim & disown
		gtk-launch Alacritty
	ﬓ	rofi -show drun

		gtk-launch slack
	ﭮ	gtk-launch discord
		alacritty -e neomutt & disown

		gtk-launch steam
		gtk-launch spotify
EOF
