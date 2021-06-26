#!/bin/sh

# A dwm_bar function that shows the current artist, track, duration, and status from Spotify using playerctl
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: spotify, playerctl

# NOTE: The official spotify client does not provide the track position or shuffle status through playerctl. This does work through spotifyd however.

if ps -C spotify > /dev/null; then
    PLAYER="spotify"
fi

if [ -z "$PLAYER" ]; then
    printf "?"
fi

if [ "$PLAYER" = "spotify" ]; then
    STATUS=$(playerctl -p spotify status)

    if [ "$STATUS" = "Playing" ]; then
		STATUS="❚❚"
    else
        STATUS="▶"
    fi
    
    if [ "$PLAYER" = "spotify" ]; then
        printf "$STATUS"
    fi
fi
