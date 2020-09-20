if [ ${PERSO_ENABLED} = 1 ] ; then

 fput () { 
  /usr/bin/curl -n -T "$1" ftp://192.168.0.254/Disque\ dur/VidÃ©os/
  # lftp -e 'cd "Disque Dur/Téléchargement"; put $1; bye' -u freebox 192.68.0.254
 }

 fboxremote () { 
  declare -A fb

  fb[red]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=red'"
  fb[blue]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=blue'"
  fb[yellow]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=yellow'"
  fb[green]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=green'"
  fb[ok]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=ok'"
  fb[left]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=left'"
  fb[right]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=right'"
  fb[up]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=up'"
  fb[down]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=down'"
  fb[free]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=home'"
  fb[power]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=power'"
  fb[pplus]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=prgm_inc'"
  fb[pmoins]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=prgm_dec'"
  fb[vplus]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=vol_inc'"
  fb[vmoins]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=vol_dec'"
  fb[mute]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=mute'"
  fb[tf1]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1'"
  fb[f2]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=2'"
  fb[f3]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=3'"
  fb[cplus]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=4'"
  fb[f5]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=5'"
  fb[m6]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=6'"
  fb[arte]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=7'"
  fb[d8]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=8'"
  fb[w9]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9'"
  fb[tmc]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=0'"
  fb[nt1]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1'"
  fb[nrj12]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=2'"
  fb[lcp]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=3'"
  fb[f4]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=4'"
  fb[bfm]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=5'"
  fb[itele]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=6'"
  fb[d17]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=7'"
  fb[gulli]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=8'"
  fb[fo]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9'"
  fb[tmc]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=2' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=0'"
  fb[pp]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=2' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=6'"
  fb[ng57]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=5' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=7'"
  fb[ng58]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=5' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=8'"
  fb[tv5m]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=7' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9'"
  fb[ps]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1'"
  fb[asi]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=4'"
  fb[f24]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=5'"
  fb[gameone]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=8'"
  fb[gameoneplusun]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=9'"
  fb[nl]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=1' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=2' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=3'"
  fb[tna]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=3' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=6' ; wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=3'"
  fb[vplus]="wget -q -O /dev/null 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=vol_inc'"
  fb[vplus10]="fboxremote10_func 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=vol_inc'"
  fb[vmoins10]="fboxremote10_func 'http://hd1.freebox.fr/pub/remote_control?code=54847719&key=vol_dec'"

  if [[ " ${!fb[@]} " =~ " ${1} " ]] && [[ -n ${1} ]]; then
   echo "Command sent to Freebox TV BOX: " ${fb[$1]}
   ${fb[$1]}
  else
   echo "Usage: ${FUNCNAME[0]} CHANNEL"
   echo "CHANNEL list:"
   echo "${!fb[@]}" | tr " " "\n" | column
  fi
 }

 fboxremote10_func () { 
  for run in {1..10}; do wget -q -O /dev/null $1 ; done
 }
fi
