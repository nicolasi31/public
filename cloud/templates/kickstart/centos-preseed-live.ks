lang fr_FR.UTF-8
keyboard fr
timezone Europe/Paris --isUtc
auth --useshadow --enablemd5
selinux --enforcing
services --enabled=NetworkManager --disabled=network,sshd

# Root password
rootpw --iscrypted $6$K2nKf02kVKG68960$OywvoaViphSITuro/liKvCj7Pm/CH/xqzz/lsoXyaKSR1lYf0vHAqSUc483a9MCCBkIwfr/hNMfqwxqVO0OEg1

# Workaround for the grubby issue on live media (see https://bugzilla.redhat.com/show_bug.cgi?id=1153410)
# repo --name=base --baseurl=http://mirror.centos.org/centos/7.1.1503/os/x86_64/ --excludepkgs=grubby
# repo --name=grubby --baseurl=http://vault.centos.org/7.0.1406/os/x86_64/ --includepkgs=grubby

%packages
dhclient
ethtool
%end

%post

livedir="LiveOS"
for arg in \`cat /proc/cmdline\` ; do
  if [ "\${arg##rd.live.dir=}" != "\${arg}" ]; then
    livedir=\${arg##rd.live.dir=}
    return
  fi
  if [ "\${arg##live_dir=}" != "\${arg}" ]; then
    livedir=\${arg##live_dir=}
    return
  fi
done

# add fedora user with no passwd
action "Adding live user" useradd \$USERADDARGS -c "Live System User" liveuser
passwd -d liveuser > /dev/null
usermod -aG wheel liveuser > /dev/null

# Remove root password lock
passwd -d root > /dev/null

%end
