#!/bin/bash

DESKFILESDIR="${HOME}/desktopfilessource/"

  case "${1}" in 
   install) 
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-user01@server02.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-user01@nextcloud.example.com.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-user01@gmail.com.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-mpv.clipboard.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-radio.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-tv.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-switchaudio.desktop
    xdg-desktop-menu install --novendor ${DESKFILESDIR}Perso.directory ${DESKFILESDIR}perso-win10dmz.desktop
    ;;
   uninstall)
    xdg-desktop-menu uninstall perso-user01@server02.desktop
    xdg-desktop-menu uninstall perso-user01@nextcloud.example.com.desktop
    xdg-desktop-menu uninstall perso-user01@gmail.com.desktop
    xdg-desktop-menu uninstall perso-mpv.clipboard.desktop
    xdg-desktop-menu uninstall perso-radio.desktop
    xdg-desktop-menu uninstall perso-tv.desktop
    xdg-desktop-menu uninstall perso-switchaudio.desktop
    xdg-desktop-menu uninstall perso-win10dmz.desktop
    ;;
   *) /bin/echo -e "Usage: ${FUNCNAME[0]} install|uninstall" ;;
  esac

# gsettings get org.gnome.desktop.app-folders folder-children

# gsettings get org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Perso/ excluded-apps
# gsettings get org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/AudioVideo/ excluded-apps

# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Perso/ excluded-apps "['perso-mpv.clipboard.desktop', 'perso-switchaudio.desktop', 'perso-tv.desktop', 'perso-radio.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.gedit.desktop']"
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/AudioVideo/ excluded-apps "['perso-mpv.clipboard.desktop', 'perso-tv.desktop', 'perso-radio.desktop', 'perso-vlc.desktop']"

