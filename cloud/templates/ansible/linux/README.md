[[_TOC_]]

# Ansible examples

## Update file ./production/hosts 

## Type the following command
```shell
ansible-playbook -i production site.yml
ansible-playbook -i production nginx.yml
ansible-playbook -i production nginx.yml --tags=php,pgsql

ansible-playbook -i production sites.yml --tags TAG
```
### Available tags:
- banner
- centos
- common
- debian
- dhcp
- download
- etckeeper
- firewall
- hostname
- journald
- mtu
- network
- ntp
- packages
- postfix
- selinux
- services
- sshd
- sshdcerts
- staticip
- sudo
- sysctl
- systemd
- upgrade
- users

# Playbook info
```shell
ansible-playbook -i production sites.yml --list-tags
ansible-playbook -i production sites.yml --list-tasks
ansible-playbook -i production sites.yml --list-hosts
```

# Get info from clients
```shell
ansible myownhosts -i production -m setup --tree /tmp/facts -u root
ansible all -m setup --tree /tmp/facts
cat /tmp/facts/192.168.0.44 | python -m json.tool
```

# Get inventory info
```shell
ansible-inventory -i production --list --export | more
```

# Module documentation
```shell
ansible-doc -l | grep ^ios
ansible-doc -l | grep network_cli
ansible-doc cli_config
ansible-doc ios_lacp_interfaces
ansible-doc cli_config
```
