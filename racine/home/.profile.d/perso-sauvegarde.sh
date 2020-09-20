if [ ${PERSO_ENABLED} = 1 ] ; then
 sauvefichier () { 
  /bin/cp "$1" "${HOME}/$1.${HOSTNAME}.${USER:-${USERNAME}}."$(/bin/date +%Y%m%d%H%M%S)".sav"
 }

 sauvehost7z () { 
  CONTENTCOUNTER=0
  CONTENTS[${CONTENTCOUNTER}]="/boot/grub/custom.cfg"       ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/profile.d/"             ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/network/"               ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/systemd/network/"       ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/systemd/timesyncd.conf" ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/systemd/resolved.conf"  ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/postfix/"               ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/rsyslog.d"              ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/rsyslog.conf"           ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/syslog-ng/"             ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/apache/"                ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/httpd/"                 ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/nginx/"                 ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/dhcp/"                  ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/bind/"                  ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/named/"                 ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/logstash/"              ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/elasticsearch/"         ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/kibana/"                ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/sysctl.d"               ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/sysctl.conf"            ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/etc/hosts"                  ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/usr/local/bin/"             ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="/usr/local/etc/"             ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.screenrc"           ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.vimrc"              ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/gtk-2.0"     ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/conky"       ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/gtk-3.0"     ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/newsbeuter"  ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.mpdconf"            ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/mpv"         ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.config/autostart"   ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.xsession"           ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.xinitrc"            ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.Xmodmap"            ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.Xresources"         ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.gtkrc-2.0"          ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.gtkrc-2.0.mine"     ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.xscreensaver"       ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  CONTENTS[${CONTENTCOUNTER}]="${HOME}/.ssh/config"         ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))

  if [[ -e /usr/bin/crontab ]] ; then
   sudo crontab -l > /tmp/crontab-root.list
   crontab -l > /tmp/crontab-${USER:-${USERNAME}}.list
   CONTENTS[${CONTENTCOUNTER}]="/tmp/crontab-root.list" ;   CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
   CONTENTS[${CONTENTCOUNTER}]="/tmp/crontab-${USER:-${USERNAME}}.list" ; CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  fi

  if [[ -e /usr/bin/dpkg ]] ; then
   dpkg -l > /tmp/dpkg.list
   CONTENTS[${CONTENTCOUNTER}]="/tmp/dpkg.list" ;   CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  fi

  if [[ -e /usr/bin/rpm ]] ; then
   rpm -qa > /tmp/rpm.list
   CONTENTS[${CONTENTCOUNTER}]="/tmp/rpm.list" ;   CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  fi

  if [[ -e /sbin/apk ]] ; then
   /sbin/apk info -L > /tmp/apk.list
   CONTENTS[${CONTENTCOUNTER}]="/tmp/apk.list" ;   CONTENTCOUNTER=$((${CONTENTCOUNTER}+1))
  fi

  for CONTENT in "${CONTENTS[@]}"
  do
   if [[ -e ${CONTENT} ]] ; then
    EXISTINGCONTENT="${EXISTINGCONTENT} ${CONTENT}"
   fi
  done

  pushd / > /dev/null
  sudo 7z a -p -mhe=on -spf ~/${HOSTNAME}-${USER:-${USERNAME}}-$(/bin/date +%Y%m%d_%Hh%Mm%S).7z ${EXISTINGCONTENT}
  popd > /dev/null
 }
fi
