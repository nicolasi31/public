**Centos Tips and Tricks**

[[_TOC_]]

# Network
- [Linux Redhat Centos Network Configuration](Linux-Redhat-Centos-Network-Configuration.md)

# RPM / YUM / DNF

## Update Repositories
```shell
yum install yum-utils
yum-config-manager --nogpgcheck --enable --save --setopt=BaseOS.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os
yum-config-manager --nogpgcheck --enable --save --setopt=AppStream.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/AppStream/x86_64/os
yum-config-manager --nogpgcheck --enable --save --setopt=extras.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/extras/x86_64/os

yum install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/haveged-1.9.13-2.el8.x86_64.rpm
yum install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm
yum install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm
```


## YUM/DNF/RPM repository config files

```shell
[BaseOS]
name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/BaseOS/$basearch/os/
#baseurl=http://129.102.1.37/pub/CentOS/$releasever/BaseOS/$basearch/os/
baseurl=https://mirrors.ircam.fr/pub/CentOS/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[AppStream]
name=CentOS-$releasever - AppStream
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/AppStream/$basearch/os/
#baseurl=http://129.102.1.37/pub/CentOS/$releasever/AppStream/$basearch/os/
baseurl=https://mirrors.ircam.fr/pub/CentOS/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/extras/$basearch/os/
#baseurl=http://129.102.1.37/pub/CentOS/$releasever/extras/$basearch/os/
baseurl=https://mirrors.ircam.fr/pub/CentOS/$releasever/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[PowerTools]
name=CentOS-$releasever - PowerTools
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/
#baseurl=http://129.102.1.37/pub/CentOS/$releasever/PowerTools/$basearch/os/
baseurl=https://mirrors.ircam.fr/pub/CentOS/$releasever/PowerTools/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[epel]
name=Extra Packages for Enterprise Linux $releasever - $basearch
#baseurl=https://download.fedoraproject.org/pub/epel/$releasever/Everything/$basearch
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch&infra=$infra&content=$contentdir
#baseurl=http://129.102.1.37/pub/fedora/epel/$releasever/Everything/$basearch
baseurl=https://mirrors.ircam.fr/pub/fedora/epel/$releasever/Everything/$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

[epel-modular]
name=Extra Packages for Enterprise Linux Modular $releasever - $basearch
#baseurl=https://download.fedoraproject.org/pub/epel/$releasever/Modular/$basearch
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-modular-$releasever&arch=$basearch&infra=$infra&content=$contentdir
#baseurl=http://129.102.1.37/pub/fedora/epel/$releasever/Modular/$basearch
baseurl=https://mirrors.ircam.fr/pub/fedora/epel/$releasever/Modular/$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

[collaboraoffice.com_repos_CollaboraOnline_CODE-centos8]
name=created by dnf config-manager from https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos8
baseurl=https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos8
enabled=1
```

## Sort installed packages by size
```shell
rpm -qa --queryformat '%{size} %{name}\n' | sort -n -
```

