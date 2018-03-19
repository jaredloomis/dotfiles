#!/bin/bash

# Set web browser
export BROWSER=firefox-nightly

# Set desktop environment if not already set
if [ -z "$DE" ]; then
    export DE=xmonad
fi

# Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Gtk themes 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Load settings in .Xresources.
xrdb "$HOME/.Xresources"

# Set monitor power saving settings.
xset s 3600

# Set XCompose to use right windows key.
setxkbmap -option "compose:rwin"

### Start WM/DE ###

# Lowercase DE string for comparison
DE_LC=$(echo "$DE" | tr '[:upper:]' '[:lower:]')

# Xfce
if [[ $DE_LC == *"xfce"* ]]; then
    exec startxfce4
else # XMonad is default
    # Set left pointer as default cursor.
    xsetroot -cursor_name left_ptr
    # Set resolution (doesn't appear to do anything; remove)
    #xrandr -s 1920x1080
    exec xmonad
fi
