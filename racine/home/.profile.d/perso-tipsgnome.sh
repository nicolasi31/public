if [ ${PERSO_ENABLED} = 1 ] ; then
 tipsgnome () {
  echo "Some Gnome Tips:"
  echo -e "\nGet:"
  echo "gsettings get org.gnome.desktop.background picture-uri"
  echo "gsettings  list-recursively"
  echo -e "\nSet:"
  echo "gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled"
  echo "gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true"
  echo "gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false"
  echo "gsettings get org.gnome.desktop.background picture-uri 'file:///boot/grub/00-preferee.png'"
  echo "gsettings get org.gnome.desktop.screensaver picture-uri 'file:///boot/grub/00-preferee.png'"
  echo -e "\nOther:"
  echo "/usr/bin/gnome-desktop-item-edit ~/Bureau/ --create-new"
 }
fi

