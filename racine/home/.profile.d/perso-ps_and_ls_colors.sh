if [ ${PERSO_ENABLED} = 1 ] ; then
 COLOR_RESET="\033[0m";
 COLOR_BLUE="\033[38;5;38m";
 COLOR_ORANGE="\033[38;5;214m";
 COLOR_RED="\033[38;5;160m";
 COLOR_GREEN="\033[38;5;10m";
 COLOR_YELLOW="\033[38;5;226m";
 COLOR_WHITE="\033[38;5;256m";

 case "${USER:-${USERNAME}}" in
  root)
   PS1SEPARATOR="#"
   if [ "$VMOUPAS" != "none" ]; then
    COLOR1=${COLOR_RED}
    COLOR2=${COLOR_BLUE}
   elif [ $SSH_TTY ]; then
    COLOR1=${COLOR_RED}
    COLOR2=${COLOR_ORANGE}
   else
    COLOR1=${COLOR_RED}
    COLOR2=${COLOR_YELLOW}
   fi
   export LS_COLORS="rs=0:di=00;33:ln=00;36:mh=00:pi=40;34\
:so=00;35:do=00;35:bd=40;34;00:cd=40;34;00:or=40;31;00:su=37;41:sg=30;43:ca=30;\
41:tw=30;42:ow=00;31;42:st=37;44:ex=00;31:*.tar=00;32:*.tgz=00;32:*.arj=00;32:*\
.taz=00;32:*.lzh=00;32:*.lzma=00;32:*.tlz=00;32:*.txz=00;32:*.zip=00;32:*.z=00;\
32:*.Z=00;32:*.dz=00;32:*.gz=00;32:*.lz=00;32:*.xz=00;32:*.bz2=00;32:*.bz=00;32\
:*.tbz=00;32:*.tbz2=00;32:*.tz=00;32:*.deb=00;32:*.rpm=00;32:*.jar=00;32:*.war=\
00;32:*.ear=00;32:*.sar=00;32:*.rar=00;32:*.ace=00;32:*.zoo=00;32:*.cpio=00;32:\
*.7z=00;32:*.rz=00;32:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00\
;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.t\
iff=00;35:*.png=00;35:*.svg=00;35:*.svgz=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00\
;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.webm=00;35:*.ogm=00;35:*\
.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00\
;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.f\
lv=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.cgm=00;35:\
*.emf=00;35:*.axv=00;35:*.anx=00;35:*.ogv=00;35:*.ogx=00;35:*.aac=00;36:*.au=00\
;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*\
.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00\
;36:"
   export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  ;;
  *)
   PS1SEPARATOR="$"
   if [ "$VMOUPAS" != "none" ]; then
    COLOR1=${COLOR_GREEN}
    COLOR2=${COLOR_BLUE}
   elif [ $SSH_TTY ]; then
    COLOR1=${COLOR_GREEN}
    COLOR2=${COLOR_ORANGE}
   else
    COLOR1=${COLOR_GREEN}
    COLOR2=${COLOR_YELLOW}
   fi
  ;;
 esac

 export PS1OLD=${PS1}
 PS1="\[${COLOR1}\]\u";
 PS1+="\[${COLOR2}\]@";
 PS1+="\[${COLOR1}\]\h";
 PS1+="\[${COLOR2}\]:";
 PS1+="\[${COLOR1}\]\W";
 PS1+="\[${COLOR2}\]${PS1SEPARATOR} ";
 PS1+="\[${COLOR_RESET}\]";
 export PS1;

# export PS1COLOR=${PS1} ; export PS1=${PS1OLD}

#        if [ "${USER:-${USERNAME}}" = "root" ] ; then export PS1="\u@\h:\w# "
#        else export  PS1="\u@\h:\w$ "
#        fi

fi
