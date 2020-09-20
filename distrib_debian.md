**Debian Tips and Tricks**

[[_TOC_]]

# Network
- [Debian Network Configuration](/linux-debian-network-configuration.md)

# Packages

## /etc/apt/sources.list.d/perso.list

```shell
deb https://mirrors.ircam.fr/pub/debian/          bullseye            main contrib non-free
deb https://mirrors.ircam.fr/pub/debian/          bullseye-updates    main contrib non-free
deb https://mirrors.ircam.fr/pub/debian/          bullseye-backports  main contrib non-free
deb https://mirrors.ircam.fr/pub/debian-security  bullseye-security   main contrib non-free

# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#deb https://download.docker.com/linux/debian buster stable

# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main

# GNS3
#deb http://ppa.launchpad.net/gns3/ppa/ubuntu zesty main
```

## Sort installed packages by size
```shell
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
```

## Multiple packages search
```shell
dpkg -l | awk '{ print $2 }' | sed "s/[0-9]*$//" | sort -n | uniq -c | sort -n
```

## Package compilation
```shell
apt-get build-dep mplayer
apt-get source mplayer
fakeroot debian/rules binary
```

# OpenSSH: disable ipv6 and regenerate host certificates
```shell
sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config
dpkg-reconfigure --frontend=noninteractive openssh-server
```

# Regenerate autosigned certificates (debian alternative)
```shell
make-ssl-cert generate-default-snakeoil --force-overwrite
```

# Timezone
```shell
ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections
dpkg-reconfigure --frontend=noninteractive tzdata
```

# Locales
```shell
echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections
echo 'locales locales/default_environment_locale select C.UTF-8' | debconf-set-selections
apt install locales
dpkg-reconfigure --frontend=noninteractive locales
```


