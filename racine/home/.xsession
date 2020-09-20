unset LC_ALL
export LANG=fr_FR.UTF-8
export LC_MESSAGES=fr_FR.UTF-8
export LC_TIME=fr_FR.UTF-8

export XKB_DEFAULT_LAYOUT=fr
export XKB_DEFAULT_MODEL=pc101
export XKB_DEFAULT_VARIANT=latin9
export XKB_DEFAULT_OPTIONS=terminate:ctrl_alt_bksp,

# xrdb -merge ~/.Xresources
# xmodmap ~/.Xmodmap

/usr/bin/xset s off -dpms -b
# /usr/bin/xset m 4/2 0

# /usr/bin/setxkbmap fr -option terminate:ctrl_alt_bksp

# /usr/bin/xhost +server02

# /usr/bin/autocutsel -selection CLIPBOARD -fork
# /usr/bin/autocutsel -selection PRIMARY -fork

# /usr/bin/synclient VertEdgeScroll=1
# /usr/bin/synclient TapButton1=1
# /usr/bin/synclient TapButton2=2
# /usr/bin/synclient TapButton3=3

# /usr/bin/xinput list-props "$device_name_or_number"
# export device_name_or_number="Logitech K400"
# /usr/bin/xinput set-prop "$device_name_or_number" "Evdev Middle Button Emulation" 1
# /usr/bin/xinput set-prop "$device_name_or_number" "Evdev Third Button Emulation" 1
# /usr/bin/xinput set-prop "$device_name_or_number" "Evdev Wheel Emulation" 1

# /usr/bin/xsetroot -solid "#000000"
# /usr/bin/feh --bg-scale '/boot/grub/00-preferee.png'

# /usr/bin/xbacklight -set 90
# killall conky urxvtd xscreensaver
# /usr/bin/conky -d
# /usr/bin/conky -d -c ~/.config/conky/conky-logs.conf
# /usr/bin/urxvtd -q -f

# /usr/bin/xscreensaver &

# pcmanfm --desktop &

# exec xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &

### Use XToolkit in java applications
# export AWT_TOOLKIT=XToolkit

# /usr/bin/mpd .mpdconf

# exec /usr/bin/i3 -V -d all >> ~/.config/i3/logfile
# exec /usr/bin/i3 >> ~/.config/i3/logfile
# exec /usr/bin/twm
# exec /usr/local/bin/sway
exec /usr/bin/gnome-session

