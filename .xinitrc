#!/bin/bash
export BROWSER=chromium
export DE=xmonad

# Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Gtk themes 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Load settings in .Xresources.
xrdb "$HOME/.Xresources"

# Set power saving settings.
#xset s blank
xset s 3600
#xset dpms 

# Set XCompose to use right windows key.
setxkbmap -option "compose:rwin"

### Xfce ###
#exec startxfce4

### XMonad ###
# Set left pointer as default cursor.
xsetroot -cursor_name left_ptr
# Start XMonad.
exec xmonad
#exec xmonad | dzen2
