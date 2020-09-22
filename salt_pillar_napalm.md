https://docs.saltstack.com/en/latest/topics/network_automation/index.html

Scripts pour installer salt:
https://repo.saltstack.com/

Normalement pas besoin d'installer 
root@centos01:salt# rpm -qa | grep salt
salt-minion-3001.1-1.el8.noarch
salt-master-3001.1-1.el8.noarch
salt-repo-latest-3.el7.noarch
salt-3001.1-1.el8.noarch

pip3 install salt salt-napalm napalm napalm-base napalm-ios napalm-junos napalm-nxos


root@centos01:salt# pwd
/etc/salt
root@centos01:salt# grep -v "^$\|^#" proxy
add_proxymodule_to_opts: True
master: 127.0.0.1
file_roots:
  base:
    - /etc/salt
pillar_roots:
  base:
    - /etc/salt/pillar
root@centos01:salt# grep -v "^$\|^#" minion
file_roots:
  base:
    - /etc/salt
pillar_roots:
    - /etc/salt/pillar
root@centos01:salt# grep -v "^$\|^#" master
file_roots:
  base:
    - /etc/salt
pillar_roots:
  base:
    - /etc/salt/pillar



root@centos01:pillar# pwd
/etc/salt/pillar
root@centos01:pillar# cat top.sls 
base:
  ciscolab:
    - sbx-nxos-mgmt-cisco-com
#  router1:
#    - router1
#  router2:
#    - router2
#  switch1:
#    - switch1
#  switch2:
#    - switch2
#  cpe1:
#    - cpe1
root@centos01:pillar# cat sbx-nxos-mgmt-cisco-com.sls 
proxy:
  proxytype: napalm
  driver: nxos_ssh
  host: sbx-nxos-mgmt.cisco.com
  username: admin
  password: 'Admin_1234!'
  optional_args:
    port: 8181
#    use_keys: False


https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.napalm_network.html
https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.iosconfig.html
https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.ciscoconfparse_mod.html
https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.bigip.html
https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.junos.html

salt 'ciscolab' net.config source='running'

salt 'ciscolab' net.cli "show version" 

salt 'ciscolab' net.environment

salt 'ciscolab' net.facts

salt 'ciscolab' net.interfaces

salt 'ciscolab' net.ipaddrs

salt 'ciscolab' net.arp

salt 'ciscolab' net.mac

salt 'ciscolab' net.lldp

salt 'ciscolab' net.optics

salt 'ciscolab' net.ping 8.8.8.8 ttl=3 size=65468

salt 'ciscolab' net.traceroute 8.8.8.8 source=127.0.0.1 ttl=5 timeout=1

salt 'ciscolab' net.load_config text='ntp peer 192.168.0.1'

salt 'ciscolab' net.load_template set_ntp_peers peers=[192.168.0.1]  # uses NAPALM default templates

salt 'ciscolab' net.load_template salt://templates/example.jinja debug=True  # Using the salt:// URI

# render remote template
salt -G 'os:junos' net.load_template http://bit.ly/2fReJg7 test=True debug=True peers=['192.168.0.1']
salt -G 'os:ios' net.load_template http://bit.ly/2gKOj20 test=True debug=True peers=['192.168.0.1']

salt 'ciscolab' net.patch https://example.com/running_config.patch


salt 'ciscolab' net.save_config source=running

salt 'ciscolab' snmp.config

salt 'ciscolab' users.config

https://docs.saltstack.com/en/master/topics/installation/nxos.html
salt 'ciscolab'  net.cli "show guestshell detail" 

