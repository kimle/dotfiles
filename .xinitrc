#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

# [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb merge ~/.Xresources

#trackpoint config
#xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
#xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
#xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
#xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
#xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 1.5
xinput set-prop 11 274 1.0

# compton -cb &
xset +fp /usr/share/fonts/local
xset fp rehash

# sh ~/.fehbg &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec awesome
exec i3
