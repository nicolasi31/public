if [ ${PERSO_ENABLED} = 1 ] ; then

 genvimrc () {   
  MYVIMRCFILE=${HOME}/.vimrc
  if [ -f /etc/redhat-release ]; then MYVIMRCFILE=${HOME}/.virc ; fi

  if [ -e ${MYVIMRCFILE} ] ; then
   /bin/echo -e "${MYVIMRCFILE} already exist."
   return 0
  fi

  /bin/echo -e "Generating ${MYVIMRCFILE}"
  cat >> ${MYVIMRCFILE} << _EOF_
set nonumber
set history=500
set nopaste
set autoread
set langmenu=fr
set wildmenu
_EOF_
 }

#########################################################################

 genscreenrc () {
  MYSCREENRCFILE=${HOME}/.screenrc

  if [ -e ${MYSCREENRCFILE} ] ; then
   /bin/echo -e "${MYSCREENRCFILE} already exist."
   return 0
  fi

  /bin/echo -e "Generating ${MYSCREENRCFILE}"
  cat >> ${MYSCREENRCFILE} << _EOF_
deflogin on
defshell -bash
vbell on
vbell_msg "   Wuff  ----  Wuff!!  "
defscrollback 1024
bind ^k
bind ^\
bind \\ quit
bind K kill
bind I login on
bind O login off
bind } history
termcapinfo vt100 dl=5\E[M
termcapinfo xterm*|rxvt*|kterm*|Eterm* hs:ts=\E]0;:fs=\007:ds=\E]0;\007
termcapinfo xterm*|linux*|rxvt*|Eterm* OP
termcapinfo xterm 'is=\E[r\E[m\E[2J\E[H\E[?7h\E[?1;4;6l'
defnonblock 5
defscrollback 1024
startup_message off
termcapinfo xterm|xterms|xs|rxvt|urxvt|urxvtc ti@:te@
shelltitle $USER
hardstatus on
hardstatus alwayslastline
hardstatus string "%{=b Kg} %H %{= Kk}|%{= KW} %-Lw%{= yk}%n %f %t%{-}%+Lw %=%{= Kk}|%{= KW} Sess:%{=b Kg} %S %{= Kk}|%{= KW} Load:%{=b Kg} %l %{= Kk}|%{= KW} %D %d/%m/%Y%{=b Kg} %c:%s"
unsetenv PROMPT_COMMAND
screen -t ${USER:-${USERNAME}}
screen -t root sudo -i
_EOF_
 }

#########################################################################

 gentmuxconf () {
  MYTMUXCONF=${HOME}/.tmux.conf

  if [ -e ${MYTMUXCONF} ] ; then
   /bin/echo -e "${MYTMUXCONF} already exist."
   return 0
  fi

  /bin/echo -e "Generating ${MYTMUXCONF}"
  cat >> ${MYTMUXCONF} << _EOF_
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
#
# set default TERM
set -g default-terminal "screen-256color"
_EOF_

 }

#########################################################################

 gensudofile () {
  if [ $# != 1 ] ; then
   /bin/echo -e "Usage:\n" \
    "${FUNCNAME[0]} MY_USER\n" \
    "${FUNCNAME[0]} user01"
   return 0
  fi

  MYUSER="${1}"

  if [ -e /etc/sudoers.d/${MYUSER} ] ; then
   /bin/echo -e "/etc/sudoers.d/${MYUSER} already exist."
   return 0
  fi

  /bin/echo -e "Generating /etc/sudoers.d/${MYUSER}"
  /bin/echo -e "
Defaults env_keep+=\"SSH_CLIENT SSH_CONNECTION SSH_TTY LANG ftp_proxy http_proxy https_proxy no_proxy\"

#${MYUSER}        ALL=(ALL)       NOPASSWD: ALL

#
Cmnd_Alias POWER = /sbin/shutdown, /sbin/reboot, /sbin/poweroff, /sbin/halt, /bin/systemctl reboot, /bin/systemctl poweroff, /bin/systemctl suspend, /bin/systemctl hibernate
${MYUSER} ALL=(ALL) NOPASSWD: POWER
#
#${MYUSER} ALL=(ALL) NOPASSWD:/bin/mount, /bin/umount
#${MYUSER} ALL=(ALL) NOPASSWD:/usr/bin/synclient, /usr/bin/tail
#${MYUSER} ALL=(ALL) NOPASSWD:/usr/local/bin/kled.sh
#${MYUSER} ALL=(ALL) NOPASSWD:/usr/bin/ip neigh del *
#${MYUSER} ALL=(ALL) NOPASSWD:/usr/sbin/fprobe -i eth0 127.0.0.1\:10003
" | sudo tee /etc/sudoers.d/${MYUSER} > /dev/null

  /bin/echo -e "Changing rights of /etc/sudoers.d/${MYUSER}"
  sudo chmod 440 /etc/sudoers.d/${MYUSER}

  /bin/echo -e "Changing owner of /etc/sudoers.d/${MYUSER}"
  sudo chown root:root /etc/sudoers.d/${MYUSER}
 }

#########################################################################

 gensysctlfile () {
#  MYSYSCTLFILE="/etc/sysctl.d/01-perso.conf"
  if [ -e ${MYSYSCTLFILE} ] ; then
   /bin/echo -e "${MYSYSCTLFILE} already exist."
   return 0
  fi

  if [ $# != 3 ] ; then
   /bin/echo -e "Usage:\n" \
    "${FUNCNAME[0]} MY_HOSTNAME MY_DOMAIN MY_NET_INTERFACE\n" \
    "${FUNCNAME[0]} server01 example.com eth0"
   return 0
  fi
  MYHOSTNAME="${1}"
  MYDOMAIN="${2}"
  MYINTERFACE="${3}"

  /bin/echo -e "Generating ${MYSYSCTLFILE}"
  /bin/echo -e "
kernel.domainname = ${MYDOMAIN}
kernel.hostname = ${MYHOSTNAME}

net.ipv4.ip_forward=1

net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.${MYINTERFACE}.disable_ipv6 = 1

#net.ipv4.conf.${MYINTERFACE}.proxy_arp=0
#net.ipv4.conf.${MYINTERFACE}.proxy_arp_pvlan=0

#net.ipv4.conf.all.rp_filter=1
#net.ipv4.conf.default.rp_filter=1
#net.ipv4.icmp_echo_ignore_all=0
#net.ipv4.icmp_echo_ignore_broadcasts=1
" | sudo tee ${MYSYSCTLFILE} > /dev/null

 }

#########################################################################

 genrsyslogfile () {
  MYRSYSLOGFILE=/etc/rsyslog.d/01-perso.conf

  if [ -e ${MYRSYSLOGFILE} ] ; then
   /bin/echo -e "${MYRSYSLOGFILE} already exist."
   return 0
  fi

  /bin/echo -e "Generating ${MYRSYSLOGFILE}"
  /bin/echo -e '
#*.*  @192.168.0.100:514
:msg, contains, "TCPSYNACK" -/var/log/nftables.log
& stop
:msg, contains, "TCPSYNOUT" -/var/log/nftables.log
& stop
:msg, contains, "DROPIN"      -/var/log/nftables.log
& stop
:msg, contains, "DROPFW"      -/var/log/nftables.log
& stop
:msg, contains, "CRON"      -/var/log/cron.log
& stop
:programname, contains, "node_exporter" -/var/log/node_exporter.log
& stop
:programname, contains, "prometheus" -/var/log/prometheus.log
& stop
:programname, contains, "kibana" -/var/log/kibana.log
& stop
:programname, contains, "metricbeat" -/var/log/metricbeat.log
& stop
:programname, contains, "named" -/var/log/named.log
& stop
:programname, contains, "dhcpd" -/var/log/dhcpd.log
& stop
:programname, contains, "dhcrelay" -/var/log/dhcpd.log
& stop
:programname, contains, "chronyd" -/var/log/chronyd.log
& stop
:programname, contains, "perso-mpv.clipboard.desktop" -/var/log/mpv.log
& stop
' | sudo tee ${MYRSYSLOGFILE} > /dev/null
 }

fi
