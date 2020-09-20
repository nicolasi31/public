if [ ${PERSO_ENABLED} = 1 ] ; then
 gmailsend () {
  if [[ "${1}" == 1 ]]; then
  DESTMAIL="emailaddr1@gmail.com"
  elif [[ "${1}" == 2 ]]; then
  DESTMAIL="emailaddr2@gmail.com"
 else
  echo -e "Usage: ${FUNCNAME[0]} 1|2 <FILE>\n1: emailaddr1@gmail.com\n2: emailaddr2@gmail.com\nDo not forget to install Mutt"
  return 0
  fi
# FILETOSEND="${2//+(*\/)}"
# /usr/bin/uuencode "${2}" "${FILETOSEND}" | /usr/bin/mail -s "${FILETOSEND}" ${DESTMAIL}
 echo -e "Envoi du fichier:\n${2}" | mutt -a ${2} -s "Envoi de ${2}" -- "${DESTMAIL}"
 }
fi
