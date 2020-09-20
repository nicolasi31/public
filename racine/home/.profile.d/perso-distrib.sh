if [ ${PERSO_ENABLED} = 1 ] ; then

########  Debian  ########

 if [ -f /etc/debian_version ]; then
  alias maj='apt update && apt --no-install-recommends --no-remove dist-upgrade && apt clean && apt autoclean'
 fi

########  Centos  ########

 if [ -f /etc/redhat-release ]; then
  alias maj='yum update; yum upgrade'
 fi

########  Alpine  ########

 if [ -f /etc/alpine-release ] ; then
  if [ ! $SSH_TTY ] ; then
   export TERM=screen
   resize
  fi
  alias maj='apk update ; apk upgrade'
 fi

#######  The End  #######

fi
