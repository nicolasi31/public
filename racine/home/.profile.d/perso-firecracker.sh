if [ ${PERSO_ENABLED} = 1 ] ; then
 export FCROOT="/media/donnees/virtualisation/firecracker"
 export FCSCREENRC="/tmp/fc-screenrc"
 export BRKVM86VM="pxe proxy awx"
# export BRKVM86VM=("pxe" "proxy" "awx")
 export FCAUTOVM="pxe proxy www mail ttrss nc"
# export FCAUTOVM=("pxe" "proxy" "www" "mail" "ttrss" "nc" "elk" "grafana")
 export FCDOUBLEINT="proxy"
# export FCDOUBLEINT=("proxy")

 fcstart () {   
  FCVMLIST=$(grep -m 1 iface_id ${FCROOT}/config/*.json | awk -F\" '{ print $4 }' | sed "s/^fc//" | tr "\n" " ")
  FCVMACTIV=$(/bin/ps -ef | grep firecracker\ --id | grep -v grep | sed "s/^.*--id \([[:alpha:]]*\).*/\1/" | sort -n | tr "\n" " ")
  FCVMINACTIV=$(echo ${FCVMLIST[@]} ${FCVMACTIV[@]} | tr ' ' '\n' | sort | uniq -u | tr '\n' ' ')
  if [[ " ${FCVMLIST[@]} " =~ " ${1} " ]] && [[ -n ${1} ]]; then
   sudo echo "Attempt to start ${1} MicroVM"
   if [[ -n $(sudo lsof ${FCROOT}/images/${1}.fc) ]]; then
    echo "VM HDD in use!!!"
   else
    if [[ ! -n $(ip link | grep fc${1}:) ]]; then
     echo fc${1} interface creation
     sudo ip tuntap add fc${1} mode tap
     sudo ip link set dev fc${1} mtu 1400 up
     if [[ " ${HOSTNAME} " == "zotac" ]]; then sudo ip link set dev fc${1} master brwan
     elif [[ " ${BRKVM86VM[@]} " =~ " ${1} " ]]; then sudo ip link set dev fc${1} master brkvm86
     else sudo ip link set dev fc${1} master brdmz01
     fi
    fi
    if [[ " ${FCDOUBLEINT[@]} " =~ " ${1} " ]] && [[ ! -n $(ip link | grep fc${1}2:) ]]; then
     sudo ip tuntap add fc${1}2 mode tap
     sudo ip link set dev fc${1}2 mtu 1400 master brdmz01 up
    fi
    if [[ ! -e ${FCSCREENRC} ]]; then
     cat /etc/screenrc | grep -v ^# | uniq > ${FCSCREENRC}
     echo 'defshell -bash' >> ${FCSCREENRC}
     echo 'hardstatus on' >> ${FCSCREENRC}
     echo 'hardstatus alwayslastline' >> ${FCSCREENRC}
     echo 'hardstatus string "%{=b Kg} %H %{= Kk}|%{= KW} %-Lw%{= yk}%n %f %t%{-}%+Lw %=%{= Kk}|%{= KW} Sess:%{=b Kg} %S %{= Kk}|%{= KW} Load:%{=b Kg} %l %{= Kk}|%{= KW} %D %d/%m/%Y%{=b Kg} %c:%s"' >> ${FCSCREENRC}
    fi
    [ -e /tmp/fc-${1}.sock ] && ( /bin/rm /tmp/fc-${1}.sock )
    if ! screen -list | grep -q "firecracker"; then
     screen -c ${FCSCREENRC} -S virt -t terminal -d -m
    fi
    FCSCREENCMD="screen -c ${FCSCREENRC} -S virt -X screen -t ${1} "
    ${FCSCREENCMD} firecracker --id ${1} --api-sock /tmp/fc-${1}.sock --config-file ${FCROOT}/config/fc-${1}.json
   fi
  else
   echo -e "Usage: ${FUNCNAME[0]} vm_name\n"
   echo -e "Lists:"
   echo -e "All VM: ${FCVMLIST[@]}"
   echo -e "Active VM: ${FCVMACTIV[@]}"
   echo -e "Inactive VM: ${FCVMINACTIV[@]}"
  fi
 }

 fcstop () { 
  FCVMLIST=$(grep -m 1 iface_id ${FCROOT}/config/*.json | awk -F\" '{ print $4 }' | sed "s/^fc//" | tr "\n" " ")
  FCVMACTIV=$(/bin/ps -ef | grep firecracker\ --id | grep -v "grep\|SCREEN" | sed "s/^.*--id \([[:alpha:]]*\).*/\1/" | sort -n | tr "\n" " ")
  FCVMINACTIV=$(echo ${FCVMLIST[@]} ${FCVMACTIV[@]} | tr ' ' '\n' | sort | uniq -u | tr '\n' ' ')
  if [[ " ${FCVMLIST[@]} " =~ " ${1} " ]] && [[ -n ${1} ]]; then
   sudo echo "${1} shutingdown"
   curl --unix-socket /tmp/fc-${1}.sock -i -X PUT "http://localhost/actions" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"action_type\": \"SendCtrlAltDel\" }"
   FCPID=$(ps | grep "firecracker.*${1}\.sock" | grep -v "grep\|screen" | head -n 1 | awk '{ print $2 }')
   echo -n "Waiting for ${1} (${FCPID}) to finish"
   while [[ $(ps | grep "firecracker.*${1}\.sock" | grep -v "grep\|screen" | head -n 1 | awk '{ print $2 }') ]] ; do
    echo -n "."
    sleep 1
   done
   echo ""
   sudo ip link del dev fc${1}
   if [[ " ${FCDOUBLEINT[@]} " =~ " ${1} " ]] && [[ -n $(ip link | grep fc${1}2:) ]]; then
    sudo ip link del dev fc${1}2
   fi
   /bin/rm -f /tmp/fc-${1}.sock
  else
   echo -e "Usage: ${FUNCNAME[0]} vm_name\n"
   echo -e "Lists:"
   echo -e "All VM: ${FCVMLIST[@]}"
   echo -e "Active VM: ${FCVMACTIV[@]}"
   echo -e "Inactive VM: ${FCVMINACTIV[@]}"
  fi
 }

 fcclean () { 
  FCINTLIST=$(ip link | grep ": fc" | awk -F: '{ print $2}')
  FCVMACTIV=$(/bin/ps -ef | grep firecracker\ --id | grep -v "grep\|SCREEN" | sed "s/^.*--id \([[:alpha:]]*\).*/\1/" | sort -n | tr "\n" " ")
  if [[ ${FCVMACTIV[@]} == "" ]]; then
   for FCINT in ${FCINTLIST[@]} ; do
    sudo ip link del dev ${FCINT}
   done
   /bin/rm -f /tmp/fc-*.sock ${FCSCREENRC}
  else
   echo -e "Usage: ${FUNCNAME[0]}\n"
   echo -e "Emergency cleanup\nAll VM must be SHUTDOWN!"
   echo -e "Still Active VM: ${FCVMACTIV[@]}"
  fi
 }

 fcstartall () { 
  if [[ "${1}" == "YES" ]]; then
   for FCVM in ${FCAUTOVM[@]}; do
    fcstart ${FCVM}
   done
  else
   echo -e "Usage: ${FUNCNAME[0]} YES\n"
  fi
 }

 fcstopall () { 
  if [[ "${1}" == "YES" ]]; then
   #for (( idx=${#FCAUTOVM[@]}-1 ; idx>=0 ; idx-- )) ; do
   idx=${#FCAUTOVM[@]}-1
   while [ "$idx" -ge 0 ]; do
    fcstop ${FCAUTOVM[idx]}
   done
  else
   echo -e "Usage: ${FUNCNAME[0]} YES\n"
  fi
 }

fi
