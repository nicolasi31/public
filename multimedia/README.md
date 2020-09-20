**Multimedia**

[[_TOC_]]

# Usefull ressources
- [FM Radio](radio.md)
- [radio.m3u](radio.m3u)
- [tv.m3u](tv.m3u)


# gphoto2
## Take a photo using Nikon Coolpix 3200
```shell
gvfs-mount -s gphoto2
env LANG=C gphoto2 \
 --capture-image-and-download \
 --force-overwrite \
 --camera "Nikon Coolpix 3200 (PTP mode)" \
 -f "/store_00010001/DCIM/100NIKON/" \
 --filename shot.jpg \
 --debug \
 --debug-logfile=my-logfile.txt
qiv shot.jpg
rm -f shot.jpg ;  gphoto2 -D --folder /store_00010001/DCIM/100NIKON
```

# Webcam
- https://wiki.archlinux.org/index.php/Webcam_Setup
- http://doc.ubuntu-fr.org/webcam
```shell
mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot
raspivid \
 -t 0 \
 -w 320 \
 -h 240 \
 -fps 20 \
 -vf \
 -o - | \
ffmpeg \
 -y \
 -i pipe:0 \
 -s 320x240 \
 -f video4linux2 \
 -f mpeg1video \
 -b 400k \
 -r 30 \
 http://192.168.1.8:8082/monmdp/320/240/
```

# imagemagick
## image resize
```shell
mogrify -resize 1920 *.jpg
```

# pdfimages
```shell
for i in *.pdf ; do mkdir "${i:0:-4}" ; pdfimages "$i" "${i:0:-4}/${i:0:-4}" ; done
for i in *.pdf ; do mkdir "${i:0:-4}" ; cd "${i:0:-4}" ; convert ../"$i" "${i/pdf/jpg}"  ; cd .. ; done
```

# mpv
## 3d film on non-3d TV
```shell
mpv --vf="stereo3d=sbs2l:ml" toto.mkv
```

# vlc
## FreeboxTV streaming
### Serveur :
```shell
nvlc http://mafreebox.freebox.fr/freeboxtv/playlist.m3u --sout=#rtp{sdp=rtsp://192.168.0.8:2022/freebox} -I ncurses
/usr/bin/nvlc ~/Downloads/freebox-playlist.m3u --sout '#standard{access=http,mux=ts,dst=192.168.0.8:2022}' -I ncurses
```

### Client :
```shell
vlc rtsp://192.168.0.8:2022/freebox
vlc http://192.168.0.8:2022/
```

### client script
```shell
vlc http://192.168.0.8:2022 & urxvtc -g 44x48+1300 -e ssh -t nicolas@192.168.0.8 '/usr/bin/screen -AmS vlc /usr/bin/vlc --sout "#standard{access=http,mux=ts,dst=192.168.0.8:2022}" -I ncurses ~/Downloads/freebox-playlist.m3u'
```

## Draft
```shell
cvlc -vvv --color v4l:///dev/video0:norm=secam:frequency=543250:size=640x480:channel=0:adev=/dev/dsp:audio=0 --sout '#transcode{vcodec=mp4v,acodec=mpga,vb=3000,ab=256,venc=ffmpeg{keyint=80,hurry-up,vt=800000},deinterlace}:rtp{mux=ts,dst=239.255.12.13,port=5004}' --ttl 12
cvlc v4l2:// :v4l2-dev=/dev/video0 :v4l2-width=640 :v4l2-height=480 --sout="#transcode{vcodec=h264,vb=800,scale=1,acodec=mp4a,ab=128,channels=2,samplerate=44100}:rtp{sdp=rtsp://:8554/live.ts}" -I dummy
cvlc "v4l2://" --v4l-vdev="/dev/video0" --v4l-adev="/dev/null" --sout #transcode{vcodec=theo,vb=256}:standard{access=http,mux=ogg,dst=:1234}" -I dummy
```

# Handbrake
```shell
INPUTFILE="/path/to/inputfile.mkv"

HandBrakeCLI -T -E ca_aac -w 640 -l 291 -i "${INPUTFILE}" -o "${INPUTFILE::-4}.reenc.mkv"
HandBrakeCLI -e vp9  --all-audio -s "1,2,3,4,5,6,7,8,9" -i "${INPUTFILE}" -o "${INPUTFILE::-3}reenc.vp9.mkv"
HandBrakeCLI -e x265 --all-audio -s "1,2,3,4,5,6,7,8,9" -i "${INPUTFILE}" -o "${INPUTFILE%???}reenc.mp4"

HandBrakeCLI --preset-import-gui -i "${INPUTFILE}" -o "${INPUTFILE%???}reenc.mkv"
```

# ffmpeg
## Convert flv into avi
```shell
ffmpeg -i mavideo.flv mavideo.avi  
```

## Convert flac into mp3
```shell
ffmpeg -i input.flac -ab 196k -ac 2 -ar 48000 output.mp3
foreach i in *.flac ; do ffmpeg -i ${i} -ab 196k -ac 2 -ar 48000 "${i%flac}mp3" ; done
```

# mencoder
## Convert flv into avi (MPEG4/DivX) (2 passes, better quality)
```shell
mencoder video.flv -ovc lavc -lavcopts vcodec=mpeg4:vpass=1 -oac copy -o a.avi
mencoder video.flv -ovc lavc -lavcopts vcodec=mpeg4:vpass=2 -oac copy -o a.avi
```

# Convert directory content into CBZ (ZIP) or CBR (RAR)
```shell
foreach i in * ; do zip -9 ${i}.cbz ${i}/*.jpg ${i}/*.JPG ; done
```

----

![alt text](/multimedia/galaxies-12448.png "galaxies-12448.png")

----

![alt text](/multimedia/Great_Observatories_Origins_Deep_Survey_2003_2_-_4096x2160.png "Great_Observatories_Origins_Deep_Survey_
2003_2_-_4096x2160.png")

----

![alt text](/multimedia/Great_Observatories_Origins_Deep_Survey_2003_2.png "Great_Observatories_Origins_Deep_Survey_2003_2.png")

----

![alt text](/multimedia/749083_download-hubble-space-images-2817-4863x3353-px-high-resolution_4863x3353_h.jpg "749083_download-h
ubble-space-images-2817-4863x3353-px-high-resolution_4863x3353_h.jpg")

----

![alt text](/multimedia/planisphere-continent.jpg "planisphere-continent.jpg")

