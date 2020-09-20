**Misc. UNIX Commands**

[[_TOC_]]


# grep
## multiple
```shell
dpkg -l | egrep -i "(nvidia|vdpau)"
```

# sed
## extract section of a text file
```shell
sed -n '/GigabitEthernet5\/11/,/\!/p' router-confg
```

## Replace Option whatever it's commented or not
```shell
sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config
```

# Find
## multiple find
```shell
find ./ \( -iname "*.zip" -or -iname "*.srr" -or -iname "*.nzb" -or -iname "*.nfo" \)  -exec ls -al {} \;
```

## logs clean up
```shell
find /var/log -type f \( -iname "*.gz" -or -iname "*.[0-9]" \) -exec rm {} \;
```
> alternative
```shell
find /var/log -type f -iname "*.gz" -exec rm {} \; -or -iname "*.[0-9]" -exec rm {} \;
```

## Last logs display
```shell
find /var/log -type f -exec tail -n 0 -f {} \;
```
> alternative
```shell
tail -n 0 -f $(find /var/log -type f)
```

## Research Exception
```shell
find ./ -type f -a -not -iname "*.jpg"
```

# AWK
## Sum 1st colums of a du command result
```shell
du -sm /mnt/donnees/musique/audio/[fF]* | awk '{for (i=1; i<=NF; i++) s=s+$i}; END{print s}'
```
## Substring
```shell
tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}'
```


# Strings
## Mass File Renaming
```shell
foreach i in *.srt ; do mv $i foobar.s02e${i:17:2}.srt ; done
```

## substitution
> Replace \n by \|
```shell
cat toto.txt | awk 1 ORS='\\\|''
cat toto.txt | sed ':a;N;$!ba;s/\n/\\\|/g'
cat toto.txt | perl -p -e 's/\n/\\\|/'
```

# udev : reload rules
```shell
udevadm trigger
```

# pv : workaround to see trafic rate of cp / mv / dd / ... commands
- http://unix.stackexchange.com/questions/65077/is-it-possible-to-see-cp-speed-and-copied
```shell
dd if=/dev/urandom | pv | dd of=/dev/null
pv inputfile > outputfile
tar cf - sourceDirectory | pv | (cd destinationDirectory; tar xf -)
ssh server1 "tar czf – /somedir/" | pv | ssh server2 "cd /somedir/; tar xf -
```

# Parallel
> convert all flac into mp3
```shell
parallel ffmpeg -i {} -qscale:a 0 {.}.mp3 ::: *.flac
```
> Ping 3 hosts
```shell
parallel -j0 ping -nc 3 ::: 192.168.1.1 192.168.1.2 192.168.0.8
```

# Asus G53SX keyboard backlight shut off
```shell
echo 0 > /sys/class/leds/asus::kbd_backlight/brightness
```

# check battery via la CLI
```shell
/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0
```

# Fonts
> List system fonts
```shell
fc-list
```
- http://www.saltycrane.com/blog/2007/09/how-to-get-anti-aliased-fonts-for/

