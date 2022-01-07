#!/bin/sh

cat <<EOF | pmenu | sh &
	gtk-launch Alacritty
	gtk-launch librewolf
	alacritty -e vim & disown
﵁	~/.local/bin/toggle_dash.py

		gtk-launch slack
	ﭮ	gtk-launch discord
		alacritty -e neomutt & disown

		gtk-launch steam
		gtk-launch spotify
EOF
