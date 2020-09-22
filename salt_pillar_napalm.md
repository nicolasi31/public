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


salt 'ciscolab' net.config source='running'

