if [ ${PERSO_ENABLED} = 1 ] ; then
 tipsmultimedia () {
  echo -e "Some Multimedia Tips:

### VLC ###
VLCSOCK=\"/tmp/vlc.sock\"
VLC_PL_FILE=\"/tmp/vlc.m3u\"
vlc -I ncurses --extraintf oldrc --extraintf http --http-host 127.0.0.1 --http-port 8083 --rc-unix \${VLCSOCK} \${VLC_PL_FILE}

### Handbrake ###
INPUTFILE=\"toto.mkv\"
HandBrakeCLI -e x265 --all-audio -s \"1,2,3,4,5,6,7,8,9\" -o \"\${INPUTFILE%???}reenc.mp4\"      -i ${INPUTFILE}
HandBrakeCLI -e vp9  --all-audio -s \"1,2,3,4,5,6,7,8,9\" -o \"\${INPUTFILE::-4}.reenc.vp9.mkv\" -i \"\${INPUTFILE}\"
HandBrakeCLI -T -E ca_aac -w 640 -l 291                 -o \"\${INPUTFILE::-4}.reenc.mkv\"     -i \"\${INPUTFILE}\""

 }
fi

