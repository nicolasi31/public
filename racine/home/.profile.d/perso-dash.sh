if [ ${PERSO_ENABLED} = 0 ] ; then

 if [ "${USER:-${USERNAME}}" = "root" ] ; then export PS1='${USER:-${USERNAME}}@$(hostname)# '
 else export PS1='${USER:-${USERNAME}}@$(hostname)$ '
 fi

 export PATH="$HOME/bin:$PATH"
 export TERM=screen
 export HISTSIZE=1000
# export LANG=fr_FR.UTF-8
 export LANG=C
 export EDITOR="vi"
 export VISUAL="vi"
 export BROWSER="w3m"

 alias la='\ls -a --color=auto'
 alias ll='\ls -al --color=auto'
 alias l='\ls -a1 --color=auto'
 alias lrt='\ls -a1rt --color=auto'
 alias llrt='\ls -alrt --color=auto'

 dateshort () { /bin/date +%Y%m%d_%Hh%Mm%S ; }

 uwt () { echo -ne "\033]0;${1:-${HOSTNAME}}\007"; }

 rw () {
  old=$(stty -g) ; stty raw -echo min 0 time 5
  printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
  IFS='[;R' read -r _ rows cols _ < /dev/tty
  stty "$old" ; stty cols "$cols" rows "$rows"
 }

fi

