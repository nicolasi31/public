if [ ${PERSO_ENABLED} = 1 ] ; then
 if [[ "${MACHINE_TYPE}" == "x86_64" || "${MACHINE_TYPE}" == "i686" ]]; then
  export ipradiocmd="mpv -vo=null --no-video --no-force-window "
  alias mpa='mpv -vo=null --no-video --no-force-window --no-audio-display'
 elif [[ "${MACHINE_TYPE}" == "armv6l" || "${MACHINE_TYPE}" == "armv7l" ]]; then
  export ipradiocmd="omxplayer -s -I -o local --key-config ${HOME}/.omxplayerrc --vol -3100 "
  alias mpa='${ipradiocmd}'
  alias musique='SAVEIFS=${IFS} ; IFS=$(echo -en "\n\b") ; for i in $(ls *.mp3 *.flac) ; do ${ipradiocmd} -g "$i" ; done ; IFS=$SAVEIFS'
  alias piplayer="${ipradiocmd}"

  yt_func () { 
   ${ipradiocmd} -g $(youtube-dl -g "$1")
  }
  alias yt=yt_func

  # http://www.heyu.org/download/ , https://github.com/HeyuX10Automation/heyu/releases
  x10 () { 
   case "$1" in 
    on) /usr/local/bin/heyu turn m13 on ;;
    off) /usr/local/bin/heyu turn m13 off ;;
    [[:digit:]]) /usr/local/bin/heyu dim m13 $1 ;;
    *) echo "Usage: ${FUNCNAME[0]} on/off/1-10\n" ;;
   esac
  }
 else
  echo "MACHINE_TYPE undefined."
 fi

fi
