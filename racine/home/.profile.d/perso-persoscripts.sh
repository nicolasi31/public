if [ ${PERSO_ENABLED} = 1 ] ; then

 persoscriptsupdate () {
  # if [ ! -f ${HOME}/.bash_profile ] || [ $(grep -c MYOWNSCRIPT ${HOME}/.bash_profile) = 0 ] ; then
  if [ -f ${HOME}/.bash_profile ] ; then sed -i '/MYOWNSCRIPTSBEGIN/,/MYOWNSCRIPTSEND/d' ~/.bash_profile ; fi
  echo '
# MYOWNSCRIPTSBEGIN
if [ -d ${HOME}/.profile.d ]; then
 for i in ${HOME}/.profile.d/*.sh; do
  if [ -r $i ]; then
   . $i
  fi
 done
 unset i
fi
# MYOWNSCRIPTSEND
' >> ${HOME}/.bash_profile
  # fi
 }

fi

