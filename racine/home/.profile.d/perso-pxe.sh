if [ ${PERSO_ENABLED} = 1 ] ; then

 pxeaddclient () {
  PXEC_HOSTNAME=${1}
  PXEC_MAC_ADDR=${2}
  PXEC_IP_ADDR=${3}
  PXE_DHCPD_DST_FILE="/etc/dhcp/linux.hosts"
  [[ $# == 3 ]] || { /bin/echo -e "Usage: ${FUNCNAME[0]} HOSTNAME MAC_ADDR IP_ADDR\nExample: ${FUNCNAME[0]} foobar 52:54:00:91:c0:e1 192.168.0.101" ; return 0 ; }
  [[ -f ${PXE_DHCPD_DST_FILE} ]] || { /bin/echo -e "Destination file ${PXE_DHCPD_DST_FILE} do not exist." ; return 1 ; }
  [[ "${PXEC_MAC_ADDR}" =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]] || { echo "Invalid MAC address" ; return 1 ; }
  [[ "${PXEC_IP_ADDR}" =~ ^[0-9]+(\.[0-9]+){3}$ ]] || { echo "Invalid IP address" ; return 1 ; }

  PXE_BOOT_DST_FILE="/var/www/html/pxelinux.cfg/$(echo "${PXEC_MAC_ADDR}" | tr ":" "-" | sed "s/^/01-/")"
  [[ ! -f ${PXE_BOOT_DST_FILE} ]] || { /bin/echo -e "Destination file ${PXE_BOOT_DST_FILE} already exist." ; return 1 ; }

  [[ $(grep -c ${PXEC_HOSTNAME} ${PXE_DHCPD_DST_FILE}) == 0 ]] || { /bin/echo "${PXEC_HOSTNAME} already present in ${PXE_DHCPD_DST_FILE}" ; return 1 ; }
  [[ $(grep -c ${PXEC_MAC_ADDR} ${PXE_DHCPD_DST_FILE}) == 0 ]] || { /bin/echo "${PXEC_MAC_ADDR} already present in ${PXE_DHCPD_DST_FILE}" ; return 1 ; }
  [[ $(grep -c ${PXEC_IP_ADDR} ${PXE_DHCPD_DST_FILE}) == 0 ]] || { /bin/echo "${PXEC_IP_ADDR} already present in ${PXE_DHCPD_DST_FILE}" ; return 1 ; }

  /bin/echo -e "# Created by ${USER:-${USERNAME}}, date: $(/bin/date +%Y%m%d%H%M%S)\nhost ${PXEC_HOSTNAME} { hardware ethernet ${PXEC_MAC_ADDR}; fixed-address ${PXEC_IP_ADDR}; option host-name \"${PXEC_HOSTNAME}\"; }" >> ${PXE_DHCPD_DST_FILE}
  /bin/cp /var/www/html/pxelinux.cfg/default ${PXE_BOOT_DST_FILE}
  systemctl restart dhcpd
 }

fi
