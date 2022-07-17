#!/usr/bin/env sh

name=$(mpc --format %file% current)
if [ ! -z "$name" ]
then
    echo ~/Documents/music/"$name"
    mpc albumart ~/Documents/music/"$name" >| /tmp/eww/art
fi
