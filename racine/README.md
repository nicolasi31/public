**Usefull commands**

[[_TOC_]]

# Set Timezone
```shell
timedatectl set-timezone Europe/Paris
```

# Set Locale
```shell
localectl set-locale LANG=fr_FR.utf8
localectl set-keymap fr
localectl set-x11-keymap fr

# console
loadkeys fr

# X
setxkbmap fr
```

# Some usefull functions and commands
```shell
set completion-ignore-case on
set +o noclobber          # !!! dangerous !!! allow redirection to existing file
shopt -s checkwinsize     # check and update (LINES and COLUMNS) the window size after each command
shopt -s histappend       # When the shell exits, append to the history file instead of overwriting it

[[ $- == *i* ]] && { stty werase undef ; bind '\C-w:unix-filename-rubout' ; } # ctrl-w remove previous word

export LANG=fr_FR.UTF-8
export PATH="$HOME/bin:$PATH"
export TERM=linux

export HISTCONTROL=ignoredups
#export HISTCONTROL=ignorespace
#export HISTCONTROL=ignoreboth
export HISTFILE=${HOME}/.bash_history
export HISTFILESIZE=2000
export HISTSIZE=1000

export PAGER="less"
export EDITOR="vi"
export VISUAL="vi"
export BROWSER="w3m"

export SCREENDIR=$HOME/.screen

export LIBVIRT_DEFAULT_URI="qemu:///system"

# export XAUTHORITY=${HOME}/.Xauthority

export XKB_DEFAULT_LAYOUT=fr
export XKB_DEFAULT_MODEL=pc101
export XKB_DEFAULT_VARIANT=latin9
export XKB_DEFAULT_OPTIONS=terminate:ctrl_alt_bksp,

export DE="gnome"

# alias la='\ls -a --tabsize=0 --literal --color=auto --show-control-chars --human-readable'
alias la='\ls -a --color=auto'
alias ll='\ls -al --color=auto'
alias l='\ls -a1 --color=auto'
alias lrt='\ls -a1rt --color=auto'
alias llrt='\ls -alrt --color=auto'
 
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias df='df -h'
alias du='du -h'
alias ps='ps -ef'

alias battery='/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0'

dateshort () { /bin/date +%Y%m%d_%Hh%Mm%S ; }

uwt () { echo -ne "\033]0;${1:-${HOSTNAME}}\007"; }

# can be replaced by resize program from xterm
rw () {
 old=$(stty -g)
 stty raw -echo min 0 time 5
 printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
 IFS='[;R' read -r _ rows cols _ < /dev/tty
 stty "$old"
 stty cols "$cols" rows "$rows"
}
```

# Some usefull file update commands
```shell
export MY_HOSTNAME="server01" ; \
export MY_DOMAIN="example.com" ; \
export MY_IFACE="eth0" ; \
export MY_DNS1="192.168.0.254" ; \
export MY_DNS2="8.8.8.8" ; \
export MY_NTP1="195.83.132.135" ; \
export MY_NTP2="80.74.64.1"

export MY_FILE_SSHD="/etc/ssh/sshd_config" ; \
export MY_FILE_SYSCTL="/etc/sysctl.d/01-perso.conf" ; \
export MY_FILE_RESOLVD="/etc/systemd/resolved.conf" ; \
export MY_FILE_TSYNCD="/etc/systemd/timesyncd.conf"

export MY_GITLAB_URL_ROOT="https://gitlab.com/nicolasi31/public/-/raw/master"

sudo wget -P /etc/sysctl.d/ ${MY_GITLAB_URL_ROOT}/racine/etc/sysctl.d/01-perso.conf

sudo sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/"                    ${MY_FILE_SSHD} ; \
sudo sed -i "s/^#\{0,1\}\(PermitRootLogin \).*/\1prohibit-password/"     ${MY_FILE_SSHD} ; \
sudo sed -i "s/^#\{0,1\}\(PasswordAuthentication \).*/\1yes/"            ${MY_FILE_SSHD} ; \
sudo sed -i "s/^#\{0,1\}\(UseDNS \).*/\1no/"                             ${MY_FILE_SSHD}

sudo sed -i "s/^#\{0,1\}\(kernel.hostname *= *\).*/\1${MY_HOSTNAME}/"    ${MY_FILE_SYSCTL} ; \
sudo sed -i "s/^#\{0,1\}\(kernel.domainname *= *\).*/\1${MY_DOMAIN}/"    ${MY_FILE_SYSCTL} ; \
sudo sed -i "s/^#\{0,1\}\(.*\)ens3\(.*\)/\1${MY_IFACE}\2/g"              ${MY_FILE_SYSCTL}

sudo sed -i "s/^#\{0,1\}\(DNS=\).*/\1${MY_DNS1}/"                        ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(FallbackDNS=\).*/\1${MY_DNS2}/"                ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(Domains=\).*/\1${MY_DOMAIN}/"                  ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(LLMNR=\).*/\1no/"                              ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(MulticastDNS=\).*/\1no/"                       ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(DNSSEC=\).*/\1no/"                             ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(DNSOverTLS=\).*/\1no/"                         ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(DNSStubListener=\).*/\1no/"                    ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(Cache=\).*/\1yes/"                             ${MY_FILE_RESOLVD} ; \
sudo sed -i "s/^#\{0,1\}\(ReadEtcHosts=\).*/\1yes/"                      ${MY_FILE_RESOLVD}

sudo sed -i "s/^#\{0,1\}\(NTP=\).*/\1${MY_NTP1}/"                        ${MY_FILE_TSYNCD} ; \
sudo sed -i "s/^#\{0,1\}\(FallbackNTP=\).*/\1${MY_NTP2}/"                ${MY_FILE_TSYNCD}
```

# Retrieve scripts
```shell
MY_GITLAB_URL_ROOT="https://gitlab.com/nicolasi31/public/-/raw/master"
PERSOSCRIPTLIST="perso-00-enabled.sh perso-alias_and_variables.sh perso-cat_functions.sh perso-cisco.sh perso-cloud-hypervisor.sh perso-dash.sh perso-distrib.sh perso-download.sh perso-firecracker.sh perso-freebox.sh perso-genfile.sh perso-kvm.sh perso-mail.sh perso-miscfunctions.sh perso-mm-ipradio.sh perso-mm-iptv4sat.sh perso-mm-iptv.sh perso-network.sh perso-nftables.sh perso-per_arch.sh perso-persoscripts.sh perso-podcast.sh perso-ps_and_ls_colors.sh perso-pxe.sh perso-sauvegarde.sh perso-tipsdatabase.sh perso-tipsgnome.sh perso-tipskvm.sh perso-tipsmultimedia.sh perso-tipsnewinstall.sh perso-tipswindows.sh perso-usbkey.sh"

if [ ! -d ${HOME}/.profile.d ] ; then
 /bin/echo -e "${HOME}/.profile.d doesnt exist."
 return 0
fi

if [ ! -e ${HOME}/.bash_login ] ; then
 /bin/echo -e "${HOME}/.bash_login file doesnt exist, downloading."
 wget -P ${HOME}/ ${MY_GITLAB_URL_ROOT}/racine/home/.bash_login
fi

for PERSOSCRIPT in ${PERSOSCRIPTLIST} ; do
 if [ ! -e ${HOME}/.profile.d/${PERSOSCRIPT} ] ; then
  /bin/echo -e "${HOME}/.profile.d/${PERSOSCRIPT} file doesnt exist, downloading."
  wget -P ${HOME}/.profile.d/ ${MY_GITLAB_URL_ROOT}/racine/home/.profile.d/${PERSOSCRIPT}
 fi
done
```
