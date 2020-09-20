**XWindow**

[[_TOC_]]

# Set keyboard to french
```shell
setxkbmap fr
```

----

# Copy/paste between terminal and X/Wayland
```shell
apt-get install xsel xclip wl-clipboard

# copy to clipboard
echo test2 | xsel -b
echo test1 | xclip -selection clipboard
echo test3 | wl-copy

# paste clipboard content
xsel
xclip -o
wl-copy -o
```

----

# Fullscreen toggle
```shell
wmctrl -r :ACTIVE: -b toggle,fullscreen
```

----

# Gnome
## Get all settings
```shell
gsettings get org.gnome.desktop.background picture-uri
gsettings  list-recursively
```

## Get current background
```shell
gsettings get org.gnome.desktop.background picture-uri
gsettings get org.gnome.desktop.screensaver picture-uri 
```

## Black background
```shell
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'
```

## Image background
```shell
# MYBACKGROUND='/usr/share/images/desktop-base/desktop-background.xml'
MYBACKGROUND='file:///boot/grub/00-preferee.png'
gsettings set org.gnome.desktop.background picture-uri ${MYBACKGROUND}
gsettings set org.gnome.desktop.screensaver picture-uri ${MYBACKGROUND}
```

## System sounds disable
```shell
gsettings set org.gnome.desktop.sound event-sounds 'false'
gsettings set org.gnome.desktop.sound input-feedback-sounds 'false'
```

## Touchpad/Mouse configuration
```shell
gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
```

## Keyboard shortcuts / Keybindings configuration
```shell
gsettings get org.gnome.desktop.wm.keybindings toggle-maximized
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>less']"

###

gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-down
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down ['<Control><Alt>Down']

gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-up
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up ['<Control><Alt>Up']

gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-left
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left ['<Control><Alt>Left']

gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-right
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right ['<Control><Alt>Right']

###

gsettings get   org.gnome.desktop.wm.keybindings move-to-workspace-left
gsettings set   org.gnome.desktop.wm.keybindings move-to-workspace-left ['<Control><Shift><Alt>Left']

gsettings get   org.gnome.desktop.wm.keybindings move-to-workspace-right
gsettings set   org.gnome.desktop.wm.keybindings move-to-workspace-right ['<Control><Shift><Alt>Right']

gsettings get   org.gnome.desktop.wm.keybindings move-to-workspace-up
gsettings set   org.gnome.desktop.wm.keybindings move-to-workspace-up ['<Control><Shift><Alt>Up']

gsettings get   org.gnome.desktop.wm.keybindings move-to-workspace-down
gsettings set   org.gnome.desktop.wm.keybindings move-to-workspace-down ['<Control><Shift><Alt>Down']
```

## List application folders
```shell
gsettings get org.gnome.desktop.app-folders folder-children
```

## Add own app to own folder
```shell
xdg-desktop-menu install --novendor ./owndir.directory ./ownapp1.desktop
```
> owndir.directory : Take a look at /usr/share/desktop-directories/ content

> ownapp.desktop   : Take a look at /usr/share/applications/ content

## Exclude application from folder
```shell
gsettings get org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/owndir/ excluded-apps
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/owndir/ excluded-apps "['ownapp1.desktop', 'ownapp2.desktop']"
```

----

## GDM3
Default background :
```
/usr/share/gnome-shell/theme/noise-texture.png
```
Default themes (including fonts and background) :
```
/usr/share/gnome-shell/theme/gnome-shell.css
```

