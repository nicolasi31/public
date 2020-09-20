if [ ${PERSO_ENABLED} = 1 ] ; then 
 set bell-style none
 set completion-ignore-case on
 set +o noclobber          # !!! dangerous !!! allow redirection to existing file
 shopt -s checkwinsize     # check and update (LINES and COLUMNS) the window size after each command
 shopt -s histappend       # When the shell exits, append to the history file instead of overwriting it

[[ $- == *i* ]] && { stty werase undef ; bind '\C-w:unix-filename-rubout' ; } # ctrl-w remove previous word

# [[ $- = *i* ]] && bind TAB:menu-complete              # tab complete automatically cycle through options

 if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
   . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
  fi
 fi

 export HISTCONTROL=ignoredups
 #export HISTCONTROL=ignorespace
 #export HISTCONTROL=ignoreboth
 export HISTFILE=${HOME}/.bash_history
 export HISTFILESIZE=2000
 export HISTSIZE=1000
# export LANG=fr_FR.UTF-8
 export LANG=C
 export MACHINE_TYPE=$(uname -m)
 [ -f /usr/bin/systemd-detect-virt ] && export VMOUPAS=$(/usr/bin/systemd-detect-virt)
 export PATH="$HOME/bin:$PATH"

 export SCREENDIR=$HOME/.screen

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
# alias less='less --quiet'

 alias battery='/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0'
 alias mpc='mpc --format "%position% [[[%artist% - [%album% - ][%track% - ]]%title%]|[%file%]][ (%time%)]"'
 alias myip='/usr/bin/w3m -dump https://wtfismyip.com/text'
 alias myip2='/usr/bin/dig +short myip.opendns.com @resolver1.opendns.com'
 alias pasinks='pacmd list-sinks | grep -e "name:\|index:"'
 alias ssaver='sleep 1 ; DISPLAY=:0.0 xset dpms force off'
 alias switchaudio='if test $(pacmd list-cards | grep -c active\ profile.*analog) == 1 ; then /usr/bin/pacmd set-card-profile 0 output:hdmi-stereo ; else /usr/bin/pacmd set-card-profile 0 output:analog-stereo ; fi'

# export EDITOR="$(if [[ -n $DISPLAY ]]; then echo 'gedit -s'; else echo 'vim.tiny'; fi)"
# export VISUAL="$(if [[ -n $DISPLAY ]]; then echo 'gedit -s'; else echo 'vim.tiny'; fi)"
# export BROWSER="$(if [[ -n $DISPLAY ]]; then echo 'firefox'; else echo 'w3m'; fi)"
 export EDITOR="vi"
 export VISUAL="vi"
 export BROWSER="w3m"
 export PAGER="less"


 export DE="gnome"

# export XAUTHORITY=${HOME}/.Xauthority
 export XKB_DEFAULT_LAYOUT=fr
 export XKB_DEFAULT_MODEL=pc101
 export XKB_DEFAULT_VARIANT=latin9
 export XKB_DEFAULT_OPTIONS=terminate:ctrl_alt_bksp,
# export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,

# export GOPATH=${HOME}/go
# export PATH=${PATH}:${GOPATH}/bin

 export LIBVIRT_DEFAULT_URI="qemu:///system"

# export MPD_HOST="192.168.1.2"
fi
