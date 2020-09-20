if [ ${PERSO_ENABLED} = 1 ] ; then
 IPTV4SATOUTPUTDIR="/tmp/iptv4sat"
 IPTV4SATM3U="6-IPTV_*.m3u"
 IPTV4SATSOCK="/tmp/vlc-${USER:-${USERNAME}}-iptv4sat.sock"


#########################################################



 iptv4satlasturl () {
  echo $(curl -s https://www.iptv4sat.com/dl-iptv-french/ | grep https...www.iptv4sat.com.download-attachment| awk -F\" '{ print $2}')
 }

 iptv4satdownload () {
  IPTV4SATOUTPUTFILE="/tmp/iptv4sat-$(/bin/date +%Y%m%d_%Hh%Mm%S).zip"
  IPTV4SATOUTPUTDIR="/tmp/iptv4sat"
  wget -q -O ${IPTV4SATOUTPUTFILE} $(iptv4satlasturl)
  unzip -q -d ${IPTV4SATOUTPUTDIR} ${IPTV4SATOUTPUTFILE}
  \rm ${IPTV4SATOUTPUTFILE}
  rename 's/ /_/g' ${IPTV4SATOUTPUTDIR}/*.m3u
#  \ls -alrth ${IPTV4SATOUTPUTDIR}/*.m3u
 }

 iptv4sat () {
  if [[ ! -d ${IPTV4SATOUTPUTDIR} ]] ; then
   iptv4satdownload
  fi
#  echo  ${IPTV4SATSOCK} ${IPTV4SATOUTPUTDIR}/${IPTV4SATM3U}
  vlc -I ncurses --extraintf oldrc --extraintf http --http-host 127.0.0.1 --http-port 8085 --rc-unix ${IPTV4SATSOCK} ${IPTV4SATOUTPUTDIR}/${IPTV4SATM3U}
 }

 iptv4satlist () {
  for IPTV4SATDECADE in 191 192 193 194 195 196 197 198 199 200 201 202 ; do
   echo -e "########################################################################"
   echo -e "###############          Films from the ${IPTV4SATDECADE}0's           ###############"
   echo -e "########################################################################"
   cat ${IPTV4SATOUTPUTDIR}/${IPTV4SATM3U} | grep ^#.*${IPTV4SATDECADE} /tmp/iptv4sat/2*m3u | grep -v "^--" | sed "s/#EXTINF:-1,//" | sed "s/(\([[:digit:]]\{4\}\))/- \1/" | sort | uniq
  done
 }

 iptv4satsearch () {
  if [[ $# == 1 ]] ; then cat ${IPTV4SATOUTPUTDIR}/${IPTV4SATM3U} | grep -A 1 -i ${1} | sed "s/$/\t/" | sed "s/#EXTINF:-1,/\n/" | grep -v "^$"
  else echo "Usage : ${FUNCNAME[0]} MOT_CLE"
  fi
 }


 iptv4sataudiotrack () { if test $# = 0; then (echo atrack | nc -N -U ${IPTV4SATSOCK}) ; else (echo atrack $1 | nc -N -U  ${IPTV4SATSOCK}) > /dev/null 2>&1 ; fi ; }

 iptv4satsubtitletrack () { if test $# = 0; then (echo strack | nc -N -U  ${IPTV4SATSOCK}) ; else (echo strack $1 | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; fi ; }

 iptv4satvolume () { (echo volume $1 | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satvoldown () { (echo voldown 1 | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satvolup () { (echo volup 1 | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satfullscreen () { (echo f | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satprev () { (echo prev | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satnext () { (echo next | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satshutdown () { (echo shutdown | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satstop () { (echo stop | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satplay () { (echo play | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1 ; }

 iptv4satinfo () { echo info | nc -N -U ${IPTV4SATSOCK} ; }

 iptv4satstatus () { echo status | nc -N -U ${IPTV4SATSOCK} ; }

 iptv4sattitle () { echo get_title | nc -N -U ${IPTV4SATSOCK} ; }

 iptv4satplaylist () { echo playlist | nc -N -U ${IPTV4SATSOCK} ; }

 iptv4satzapping () {
  (echo goto 1 | nc -N -U ${IPTV4SATSOCK}) > /dev/null 2>&1
  IPTV4SATPLCOUNT=$(echo playlist | nc -N -U ${IPTV4SATSOCK} | grep "|  - " | wc -l)
#  for (( IPTV4SATPLITEM = 0; IPTV4SATPLITEM < ${IPTV4SATPLCOUNT}; IPTV4SATPLITEM++)) ; do
   for IPTV4SATPLITEM in $(seq 1 ${IPTV4SATPLCOUNT}) ; do                                                                                              
    sleep 10
    iptv4satnext 
   done
 }

fi
