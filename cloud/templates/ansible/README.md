[[_TOC_]]

# Ansible examples

## Update hosts file

## Usefull commands
```shell
ansible-playbook -i hosts pb_site.yml
ansible-playbook -i hosts nginx.yml --tags=php,pgsql
```

# Playbook info
```shell
ansible-playbook -i hosts pb_site.yml --list-tags
ansible-playbook -i hosts pb_site.yml --list-tasks
ansible-playbook -i hosts pb_site.yml --list-hosts
```

# Get info from clients
```shell
ansible myownhosts -i hosts -m setup --tree /tmp/facts -u root
ansible all -m setup --tree /tmp/facts
cat /tmp/facts/192.168.0.44 | python -m json.tool
```

# Get inventory info
```shell
ansible-inventory -i hosts --list --export | more
```

# Module documentation
```shell
ansible-doc -l | grep ^ios
ansible-doc -l | grep network_cli
ansible-doc cli_config
ansible-doc ios_lacp_interfaces
ansible-doc cli_config
```

# One line ansible command
```shell
ansible sbx -m raw -a "show ip int brief" -u admin --ssh-extra-args "-p 8181" -k -v
```

