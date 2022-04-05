#!/bin/bash

ippm="doas /usr/bin/ippm"
mode=$($ippm get perf)

if [[ $1 == "next" ]]
then
    mode=$(expr $mode + 1)
    mode=$(expr $mode % 3)
    $ippm set perf $mode
    polybar-msg hook ippm 1
    exit 0
fi

case $mode in
    0)
        echo 龍
        ;;
    1)
        echo 
        ;;
    2)
        echo ﰕ
        ;;
esac