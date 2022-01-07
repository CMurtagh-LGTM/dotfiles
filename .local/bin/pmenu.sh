#!/bin/sh

cat <<EOF | pmenu | sh &
	alacritty & disown
	gtk-launch librewolf
	alacritty -e vim & disown

		gtk-launch slack
	ﭮ	gtk-launch discord
		alacritty -e neomutt & disown

		gtk-launch steam
		gtk-launch spotify
EOF
