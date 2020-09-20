if [ ${PERSO_ENABLED} = 1 ] ; then
 VLC_RADIO_PL_FILE=/tmp/radio.m3u
 IPRADIOVLCSOCK="/tmp/vlc-${USER:-${USERNAME}}-radio.sock"

 ipradiovlc () {   
  if [ ! -f ${VLC_RADIO_PL_FILE} ] ; then
   cat > ${VLC_RADIO_PL_FILE} << _EOF_
#EXTM3U
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", France Inter\nhttp://direct.franceinter.fr/live/franceinter-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", France Culture\nhttp://direct.franceculture.fr/live/franceculture-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", France Info\nhttp://direct.franceinfo.fr/live/franceinfo-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", FIP\nhttp://direct.fipradio.fr/live/fip-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", France Musiques\nhttp://direct.francemusique.fr/live/francemusique-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Radio Classique\nhttp://broadcast.infomaniak.net/radioclassique-high.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", RMC Info\nhttp://chai5she.cdn.dvmr.fr/rmcinfo
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", RTL\nhttp://streaming.radio.rtl.fr/rtl-1-44-96
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Europe 1\nhttp://ais-live.cloud-services.paris/europe1.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Sud Radio\nhttp://broadcast.infomaniak.net/start-sud-high.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", RFI\nhttp://live02.rfi.fr/rfimonde-96k.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", RTL2\nhttp://streaming.radio.rtl2.fr/rtl2-1-44-96
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", RFM\nhttp://ais-live.cloud-services.paris/rfm.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Nostalgie\nhttp://cdn.nrjaudio.fm/audio1/fr/30601/mp3_128.mp3?origine=fluxradios
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Cherie FM\nhttp://cdn.nrjaudio.fm/audio1/fr/30201/mp3_128.mp3?origine=fluxradios
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Oui FM\nhttp://ouifm.ice.infomaniak.ch/ouifm-high.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Rire et Chansons\nhttp://cdn.nrjaudio.fm/audio1/fr/30401/mp3_128.mp3?origine=fluxradios
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Radio Campus TLS\nhttp://stream.radiotime.com/listen.m3u?streamId=10555650
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Radio Meuh\nhttp://radiomeuh.ice.infomaniak.ch/radiomeuh-128.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Lounge Radio\nhttp://nl1.streamhosting.ch
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Radio Nova\nhttp://novazz.ice.infomaniak.ch/novazz-128.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", France Bleu\nhttp://direct.francebleu.fr/live/fb1071-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Le Mouv\nhttp://direct.mouv.fr/live/mouv-midfi.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", NRJ\nhttp://cdn.nrjaudio.fm/audio1/fr/30001/mp3_128.mp3?origine=fluxradios
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Virgin Radio\nhttp://ais-live.cloud-services.paris/virgin.mp3
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Fun Radio\nhttp://streaming.radio.funradio.fr/fun-1-48-192
#EXTINF:-1 radio="true" tvg-logo="..." group-title="RADIO", Skyrock\nhttp://icecast-vip06.skyrock.net/s/natio_mp3_128k
_EOF_
   sed -i "s/\\\n/\n/" ${VLC_RADIO_PL_FILE}
  fi
#  mpv -vo=null --no-video --no-force-window --no-audio-display --loop-playlist=inf ${VLC_RADIO_PL_FILE}
#  vlc --aout pulse --sout "#standard{access=http,mux=ts,dst=192.168.0.8:2022}" -f -I http --http-host 127.0.0.1 --http-port 8083 --rc-unix ${IPRADIOVLCSOCK} ${VLC_RADIO_PL_FILE}
  vlc -I ncurses --extraintf oldrc --extraintf http --http-host 127.0.0.1 --http-port 8083 --rc-unix ${IPRADIOVLCSOCK} ${VLC_RADIO_PL_FILE}
 }



#########################################################


 ipradiovlcvolume () { (echo volume $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcvoldown () { (echo voldown 1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcvolup () { (echo volup 1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcprev () { (echo prev $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcnext () { (echo next $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcshutdown () { (echo shutdown $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcstop () { (echo stop $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcplay () { (echo play $1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1 ; }

 ipradiovlcinfo () { echo info $1 | nc -N -U ${IPRADIOVLCSOCK} ; }

 ipradiovlcstatus () { echo status $1 | nc -N -U ${IPRADIOVLCSOCK} ; }

 ipradiovlctitle () { echo get_title $1 | nc -N -U ${IPRADIOVLCSOCK} ; }

 ipradiovlcplaylist () { echo playlist $1 | nc -N -U ${IPRADIOVLCSOCK} ; }

 ipradiovlczapping () {
  (echo goto 1 | nc -N -U ${IPRADIOVLCSOCK}) > /dev/null 2>&1
  IPRADIOVLCPLCOUNT=$(echo playlist | nc -N -U ${IPRADIOVLCSOCK} | grep "|  - " | wc -l)
#  for (( IPRADIOVLCPLITEM = 0; IPRADIOVLCPLITEM < ${IPRADIOVLCPLCOUNT}; IPRADIOVLCPLITEM++)) ; do
  for IPRADIOVLCPLITEM in $(seq 1 ${IPRADIOVLCPLCOUNT}) ; do                                                                                              
   sleep 10
   ipradiovlcnext 
  done
 }


#########################################################


 ipradiompvplaylist_func () {
  unset ipradiolistarray
  unset ipradioorderarray
  declare -gA ipradiolistarray
  declare -ga ipradioorderarray

  ipradiolistarray[fculture]="http://direct.franceculture.fr/live/franceculture-midfi.mp3"            ; ipradioorderarray[0]="fculture"
  ipradiolistarray[finter]="http://direct.franceinter.fr/live/franceinter-midfi.mp3"                  ; ipradioorderarray[1]="finter"
  ipradiolistarray[finfo]="http://direct.franceinfo.fr/live/franceinfo-midfi.mp3"                     ; ipradioorderarray[2]="finfo"
  ipradiolistarray[fip]="http://direct.fipradio.fr/live/fip-midfi.mp3"                                ; ipradioorderarray[3]="fip"
  ipradiolistarray[fmusique]="http://direct.francemusique.fr/live/francemusique-midfi.mp3"            ; ipradioorderarray[4]="fmusique"
  ipradiolistarray[rclassique]="http://broadcast.infomaniak.net/radioclassique-high.mp3"              ; ipradioorderarray[5]="rclassique"
  ipradiolistarray[fbleu]="http://direct.francebleu.fr/live/fb1071-midfi.mp3"                         ; ipradioorderarray[6]="fbleu"
  ipradiolistarray[rmc]=" http://chai5she.cdn.dvmr.fr/rmcinfo"                                        ; ipradioorderarray[7]="rmc"
  ipradiolistarray[rtl]="http://streaming.radio.rtl.fr/rtl-1-44-96"                                   ; ipradioorderarray[8]="rtl"
  ipradiolistarray[europe1]="http://ais-live.cloud-services.paris/europe1.mp3"                        ; ipradioorderarray[9]="europe1"
  ipradiolistarray[sudradio]="http://broadcast.infomaniak.net/start-sud-high.mp3"                     ; ipradioorderarray[10]="sudradio"
  ipradiolistarray[rfi]="http://live02.rfi.fr/rfimonde-96k.mp3"                                       ; ipradioorderarray[11]="rfi"
  ipradiolistarray[rtl2]="http://streaming.radio.rtl2.fr/rtl2-1-44-96"                                ; ipradioorderarray[12]="rtl2"
  ipradiolistarray[rfm]="http://ais-live.cloud-services.paris/rfm.mp3"                                ; ipradioorderarray[13]="rfm"
  ipradiolistarray[ouifm]="http://ouifm.ice.infomaniak.ch/ouifm-high.mp3"                             ; ipradioorderarray[14]="ouifm"
  ipradiolistarray[rireec]="http://cdn.nrjaudio.fm/audio1/fr/30401/mp3_128.mp3?origine=fluxradios"    ; ipradioorderarray[15]="rireec"
  ipradiolistarray[nostalgie]="http://cdn.nrjaudio.fm/audio1/fr/30601/mp3_128.mp3?origine=fluxradios" ; ipradioorderarray[16]="nostalgie"
  ipradiolistarray[cheriefm]="http://cdn.nrjaudio.fm/audio1/fr/30201/mp3_128.mp3?origine=fluxradios"  ; ipradioorderarray[17]="cheriefm"
  ipradiolistarray[rcampus]="http://stream.radiotime.com/listen.m3u?streamId=10555650"                ; ipradioorderarray[18]="rcampus"
  ipradiolistarray[rmeuh]="http://radiomeuh.ice.infomaniak.ch/radiomeuh-128.mp3"                      ; ipradioorderarray[19]="rmeuh"
  ipradiolistarray[lounger]="http://nl1.streamhosting.ch"                                             ; ipradioorderarray[20]="lounger"
  ipradiolistarray[nova]="http://novazz.ice.infomaniak.ch/novazz-128.mp3"                             ; ipradioorderarray[21]="nova"
  ipradiolistarray[lemouv]="http://direct.mouv.fr/live/mouv-midfi.mp3"                                ; ipradioorderarray[22]="lemouv"
  ipradiolistarray[nrj]="http://cdn.nrjaudio.fm/audio1/fr/30001/mp3_128.mp3?origine=fluxradios"       ; ipradioorderarray[23]="nrj"
  ipradiolistarray[virgin]="http://ais-live.cloud-services.paris/virgin.mp3"                          ; ipradioorderarray[24]="virgin"
  ipradiolistarray[fun]="http://streaming.radio.funradio.fr/fun-1-48-192"                             ; ipradioorderarray[25]="fun"
  ipradiolistarray[skyrock]="http://icecast.skyrock.net/s/natio_mp3_128k"                             ; ipradioorderarray[26]="skyrock"
 }


 ipradiompvselect_func () {
  IPRADIOINDEX=""
  echo "Channel list:"
  if [[ "${MACHINE_TYPE}" == "x86_64" || "${MACHINE_TYPE}" == "i686" ]]; then
   IPRADIOLISTORDERED=""
   for IPRADIOINDEX in $@
   do
    echo ${ipradioorderarray[${IPRADIOINDEX}]}
    IPRADIOLISTORDERED+=" ${ipradiolistarray[${ipradioorderarray[${IPRADIOINDEX}]}]}"
   done
   echo ""
   ${ipradiocmd:-mpv -vo=null --no-video --no-force-window} --loop-playlist ${IPRADIOLISTORDERED}
  elif [[ "${MACHINE_TYPE}" == "armv6l" || "${MACHINE_TYPE}" == "armv7l" ]]; then
   for IPRADIOINDEX in $@
   do
    echo ${ipradioorderarray[${IPRADIOINDEX}]}
    ${ipradiocmd:-omxplayer -s -I -o local --key-config ${HOME}/.omxplayerrc --vol -3100} ${ipradiolistarray[${ipradioorderarray[${IPRADIOINDEX}]}]}
   done
   echo ""
  else
   echo "Service Unavailable"
  fi
 }

 ipradiompv () { 
  ipradiompvplaylist_func
  if [[ " ${!ipradiolistarray[@]} " =~ " ${1} " ]] && [[ -n ${1} ]]; then
   echo "IP Radio URL played: " ${ipradiolistarray[$1]}
   ${ipradiocmd:-mpv -vo=null --no-video --no-force-window} "${ipradiolistarray[$1]}"
  elif [[ ${1} == "all" ]]; then
   let IPRADIOCHANNELNBR=${#ipradioorderarray[@]}-1
   ipradiompvselect_func  $(seq 0 $IPRADIOCHANNELNBR)
  elif [[ ${1} == "rf" ]]; then
   ipradiompvselect_func 0 1 2
  elif [[ ${1} == "info" ]]; then
   ipradiompvselect_func 7 8 9
  elif [[ ${1} == "pop" ]]; then
   ipradiompvselect_func 10 11 12
  else
   echo "Usage: ${FUNCNAME[0]} CHANNEL"
   echo "or: ipradio all"
   echo "or: ipradio rf"
   echo "or: ipradio info"
   echo "or: ipradio pop"
   echo "CHANNEL list:"
   echo "${!ipradiolistarray[@]}" | tr " " "\n" | column
  fi
 }



#########################################################


fi
