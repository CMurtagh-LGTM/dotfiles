#!/usr/bin/env sh
o0="﫼"
o1=""
o2=""
o3=""
o4=""
if [ x"$@" = x$o0 ]
then
    pkill leftwm
    exit 0
elif [ x"$@" = x$o1 ]
then
    exit 0
elif [ x"$@" = x$o2 ]
then
    reboot
    exit 0
elif [ x"$@" = x$o3 ]
then
    shutdown now
    exit 0
elif [ x"$@" = x$o4 ]
then
    exit 0
fi
echo $o0
# echo $o1
echo $o2
echo $o3
# echo $o4
