#! /bin/bash

#FULL=`cat /sys/class/power_supply/BAT1/charge_full`
#NOW=`cat /sys/class/power_supply/BAT1/charge_now`

#echo "$NOW $FULL" | awk '{print ($1/$2) * 100 "%"}'

if [[ "$1" == "-fp" ]]; then
    echo "$(cat /sys/class/power_supply/BAT1/charge_now) $(cat /sys/class/power_supply/BAT1/charge_full)" |
    awk '{print ($1/$2) * 100}' |
    ack -o "[0-9]+\.[0-9]{1,2}" |
    awk '{print $1 "%"}'
else
    echo "$(cat /sys/class/power_supply/BAT1/charge_now) $(cat /sys/class/power_supply/BAT1/charge_full)" |
    awk '{print ($1/$2) * 100}' |
    ack -o "[0-9]+(?=\.)" |
    awk '{print $1 "%"}'
fi
