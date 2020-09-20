if [ ${PERSO_ENABLED} = 1 ] ; then
 VLC_TV_PL_FILE=/tmp/tv.m3u
 IPTVVLCSOCK="/tmp/vlc-${USER:-${USERNAME}}-tv.sock"


#########################################################



 iptvvlc () {   
  if [ ! -f ${VLC_TV_PL_FILE} ] ; then
   cat > ${VLC_TV_PL_FILE} << _EOF_
#EXTM3U
#EXTINF:0,1 - TF1 (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=6&nid=8442&sid=1537&frontend=1
#EXTINF:0,2 - France 2 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=201
#EXTINF:0,3 - France 3 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=202
#EXTINF:0,4 - CANAL+ (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=769&frontend=1
#EXTINF:0,5 - France 5 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=203
#EXTINF:0,6 - M6 (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1025&frontend=1
#EXTINF:0,7 - Arte (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=204
#EXTINF:0,8 - C8 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=372&flavour=sd
#EXTINF:0,9 - W9 (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1026&frontend=1
#EXTINF:0,10 - TMC (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=6&nid=8442&sid=1542&frontend=1
#EXTINF:0,11 - NT1 (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=6&nid=8442&sid=1544&frontend=1
#EXTINF:0,12 - NRJ 12 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=375
#EXTINF:0,13 - La Chaîne Parlementaire (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=226
#EXTINF:0,14 - France 4 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=376
#EXTINF:0,15 - BFM TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=400
#EXTINF:0,16 - CNews (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=679&flavour=sd
#EXTINF:0,16 - i>TELE (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=2&nid=8442&sid=516&frontend=1
#EXTINF:0,17 - CStar (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=678
#EXTINF:0,18 - Gulli (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=677
#EXTINF:0,19 - France Ô (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=238
#EXTINF:0,20 - HD1 (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=10&nid=8442&sid=2561&frontend=1
#EXTINF:0,21 - L'Equipe 21 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=994
#EXTINF:0,22 - 6ter (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1046&frontend=1
#EXTINF:0,23 - RMC Story (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=996
#EXTINF:0,24 - RMC Découverte (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=997
#EXTINF:0,25 - Chérie 25 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=998
#EXTINF:0,26 - LCI (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=776&frontend=1
#EXTINF:0,27 - franceinfo (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1173
#EXTINF:0,28 - Paris Première (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=213&flavour=ld
#EXTINF:0,29 - RTL9 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=210
#EXTINF:0,41 - CANAL+ CINEMA (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=770&frontend=1
#EXTINF:0,42 - CANAL+ SPORT (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=771&frontend=1
#EXTINF:0,47 - #ALaMaison (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1426
#EXTINF:0,50 - Game One (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=220
#EXTINF:0,51 - AB 1 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=211
#EXTINF:0,52 - Paramount Channel (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1050
#EXTINF:0,53 - TEVA (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=404&flavour=ld
#EXTINF:0,64 - M6 Music (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=430&flavour=ld
#EXTINF:0,70 - TV5 Monde (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=206
#EXTINF:0,87 - MCM (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=621&flavour=sd
#EXTINF:0,89 - Game One +1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=979&flavour=ld
#EXTINF:0,90 - Mangas (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=253
#EXTINF:0,91 - ES1 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1309
#EXTINF:0,94 - GONG (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1045
#EXTINF:0,95 - GONG MAX (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=813
#EXTINF:0,96 - Ginx (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=618&flavour=sd
#EXTINF:0,97 - Comedy Central (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1318
#EXTINF:0,99 - BET (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1135
#EXTINF:0,100 - Festival 4K (4K)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1134&flavour=hd
#EXTINF:0,119 - Eurochannel (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=959
#EXTINF:0,120 - Drive In Movie Channel (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1295&flavour=ld
#EXTINF:0,121 - Action (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=242
#EXTINF:0,122 - Paramount Décalé (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1167
#EXTINF:0,154 - Toonami (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1163
#EXTINF:0,159 - TV Pitchoun (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1371
#EXTINF:0,175 - Premiere Futebol Clube (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=755&flavour=sd
#EXTINF:0,176 - Equidia (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=212
#EXTINF:0,178 - Trace Sport Stars (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=965
#EXTINF:0,180 - Automoto (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=222
#EXTINF:0,182 - Motorvision (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1127&flavour=hd
#EXTINF:0,183 - Nautical Channel (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=255
#EXTINF:0,185 - Golf Channel (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=892
#EXTINF:0,190 - Sport en France (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1370
#EXTINF:0,202 - Crime District (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1314
#EXTINF:0,205 - Histoire (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=235
#EXTINF:0,206 - Toute l'histoire (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=250
#EXTINF:0,207 - Science & Vie TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=251
#EXTINF:0,208 - Animaux (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=248
#EXTINF:0,209 - Trek (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=252
#EXTINF:0,210 - Aerostar (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1162
#EXTINF:0,211 - Souvenirs from Earth (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=710
#EXTINF:0,212 - Ikono (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1072&flavour=hd
#EXTINF:0,214 - Myzen Nature (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=825&flavour=hd
#EXTINF:0,215 - Travel Channel (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=772&flavour=sd
#EXTINF:0,216 - Chasse et pêche (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=249
#EXTINF:0,219 - Tahiti Nui (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1297
#EXTINF:0,221 - Connaissances du monde (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1384
#EXTINF:0,231 - 01 TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1424
#EXTINF:0,232 - M6 Boutique & Co (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=359
#EXTINF:0,233 - Best of Shopping (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=358
#EXTINF:0,235 - Astro Center TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=415&flavour=sd
#EXTINF:0,236 - Demain.tv (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=227&flavour=sd
#EXTINF:0,237 - Luxe.TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=460
#EXTINF:0,238 - Men's Up TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=878&flavour=ld
#EXTINF:0,240 - World Fashion (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=724&flavour=sd
#EXTINF:0,241 - Fashion TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=221&flavour=sd
#EXTINF:0,242 - FTV HD (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=454&flavour=hd
#EXTINF:0,245 - KTO (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=223&flavour=sd
#EXTINF:0,246 - ECTV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1082&flavour=ld
#EXTINF:0,261 - RFM TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=623&flavour=sd
#EXTINF:0,262 - Melody (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=237&flavour=sd
#EXTINF:0,263 - Mezzo (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=265&flavour=sd
#EXTINF:0,264 - Mezzo Live HD (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=858&flavour=hd
#EXTINF:0,266 - Stingray Classica (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=820&flavour=hd
#EXTINF:0,271 - MCM TOP (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=622
#EXTINF:0,274 - Clubbing TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=767
#EXTINF:0,278 - C Music (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=683&flavour=sd
#EXTINF:0,279 - VH1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=233&flavour=sd
#EXTINF:0,280 - VH1 Classic (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=232&flavour=sd
#EXTINF:0,281 - OKLM (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1166
#EXTINF:0,282 - Generations TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1305
#EXTINF:0,283 - People 24 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=981&flavour=ld
#EXTINF:0,287 - Trace Urban (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=228
#EXTINF:0,288 - Trace Caribbean (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=769
#EXTINF:0,289 - Trace Toca (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1137&flavour=ld
#EXTINF:0,290 - Trace Gospel (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1136
#EXTINF:0,294 - Melody d'Afrique (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1306&flavour=ld
#EXTINF:0,301 - France 3 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=202
#EXTINF:0,301 - F3 Midi-Pyrenees (TNT)\nrtsp://192.168.0.40/fbxdvb/stream?tsid=1&nid=8442&sid=282&frontend=1
#EXTINF:0,302 - France 3 Alpes (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=283
#EXTINF:0,303 - France 3 Alsace (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=280
#EXTINF:0,304 - France 3 Aquitaine (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=284
#EXTINF:0,305 - France 3 Auvergne (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=285
#EXTINF:0,306 - France 3 Basse-Normandie (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=298
#EXTINF:0,307 - France 3 Bourgogne (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=279
#EXTINF:0,308 - France 3 Bretagne (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=286
#EXTINF:0,309 - France 3 Centre (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=287
#EXTINF:0,310 - France 3 Champagne-Ardenne (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=288
#EXTINF:0,311 - France 3 Corse Via Stella (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=289
#EXTINF:0,312 - France 3 Côte-d'Azur (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=290
#EXTINF:0,313 - France 3 Franche-Comté (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=291
#EXTINF:0,314 - France 3 Haute-Normandie (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=297
#EXTINF:0,315 - France 3 Languedoc-Roussillon (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=292
#EXTINF:0,316 - France 3 Limousin (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=293
#EXTINF:0,317 - France 3 Lorraine (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=294
#EXTINF:0,318 - France 3 Midi Pyrénées (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=295
#EXTINF:0,319 - France 3 Nord Pas-de-Calais (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=296
#EXTINF:0,320 - France 3 Paris Ile-de-France (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=257
#EXTINF:0,321 - France 3 Pays de Loire (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=299
#EXTINF:0,322 - France 3 Picardie (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=300
#EXTINF:0,323 - France 3 Poitou-Charentes (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=301
#EXTINF:0,324 - France 3 Provence-Alpes (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=302
#EXTINF:0,325 - France 3 Rhône-Alpes (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=303
#EXTINF:0,326 - NoA (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1315
#EXTINF:0,340 - France 24 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=739&flavour=sd
#EXTINF:0,341 - France 24 English (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=740&flavour=sd
#EXTINF:0,342 - France 24 Arab (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=741&flavour=sd
#EXTINF:0,343 - LCP - Assemblée Nationale 24h/24 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=688
#EXTINF:0,344 - Public Sénat (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=692
#EXTINF:0,345 - Euronews (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=205&flavour=sd
#EXTINF:0,346 - Euronews Int (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=949&flavour=sd
#EXTINF:0,347 - BFM Business (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=897
#EXTINF:0,348 - Arretsurimages.tv (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=738&flavour=sd
#EXTINF:0,350 - Sky News International (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=355&flavour=sd
#EXTINF:0,352 - Fox News (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1073&flavour=ld
#EXTINF:0,353 - Bloomberg TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=207&flavour=sd
#EXTINF:0,354 - CNBC (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=208&flavour=sd
#EXTINF:0,355 - Al Jazeera International (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=494&flavour=sd
#EXTINF:0,357 - i24 News (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1048&flavour=ld
#EXTINF:0,358 - NHK World-Japan (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=812
#EXTINF:0,359 - RT France (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1304
#EXTINF:0,420 - God TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=386&flavour=sd
#EXTINF:0,421 - Noursat (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1069&flavour=ld
#EXTINF:0,422 - Daystar (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1141&flavour=ld
#EXTINF:0,426 - BBC Entertainment (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=413&flavour=sd
#EXTINF:0,431 - Nina Novelas (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1296&flavour=ld
#EXTINF:0,432 - TPA (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1115&flavour=ld
#EXTINF:0,433 - TNH (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1129&flavour=ld
#EXTINF:0,436 - HLive (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1126&flavour=ld
#EXTINF:0,444 - A+ (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1232
#EXTINF:0,445 - Antenne A (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1143&flavour=ld
#EXTINF:0,446 - B-One TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1085&flavour=ld
#EXTINF:0,448 - Sen TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1087&flavour=ld
#EXTINF:0,449 - TVT (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1088&flavour=ld
#EXTINF:0,450 - RTB (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=774&flavour=sd
#EXTINF:0,451 - ORTB (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=810&flavour=sd
#EXTINF:0,452 - TFM (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=960&flavour=sd
#EXTINF:0,453 - Canal 2 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=781&flavour=sd
#EXTINF:0,454 - CRTV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=782&flavour=sd
#EXTINF:0,455 - STV2 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=783&flavour=sd
#EXTINF:0,456 - Equinoxe TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=833&flavour=sd
#EXTINF:0,457 - Trace Africa (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=963&flavour=sd
#EXTINF:0,458 - Télé Congo (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=784&flavour=sd
#EXTINF:0,460 - Nollywood (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=800&flavour=ld
#EXTINF:0,461 - RTI 1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=941&flavour=sd
#EXTINF:0,462 - Gabon Télévision (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=916&flavour=ld
#EXTINF:0,463 - RTG (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=917&flavour=ld
#EXTINF:0,465 - ORTM (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=785&flavour=sd
#EXTINF:0,466 - 2STV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=786&flavour=sd
#EXTINF:0,467 - RTS (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=787&flavour=sd
#EXTINF:0,468 - Nollywood Epic (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1374&flavour=ld
#EXTINF:0,469 - Africable (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=788&flavour=sd
#EXTINF:0,470 - SUD1ere (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1068&flavour=ld
#EXTINF:0,471 - TVM (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1124&flavour=ld
#EXTINF:0,472 - ORTC (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=888&flavour=ld
#EXTINF:0,473 - MBC Sat (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1123&flavour=ld
#EXTINF:0,474 - Telekreol (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1120&flavour=ld
#EXTINF:0,475 - Vox Africa (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=773&flavour=sd
#EXTINF:0,476 - Cherifla (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1373&flavour=ld
#EXTINF:0,478 - MBOA TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=837&flavour=ld
#EXTINF:0,479 - LBC Sat (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1099&flavour=ld
#EXTINF:0,480 - Medi1TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=730&flavour=sd
#EXTINF:0,481 - Canal Algérie (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=274&flavour=sd
#EXTINF:0,482 - Algérie 3 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=943&flavour=ld
#EXTINF:0,483 - Algérie 5 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=944&flavour=ld
#EXTINF:0,484 - Tamazight TV4 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=945&flavour=ld
#EXTINF:0,485 - Al Erth Al Nabawi (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1090&flavour=ld
#EXTINF:0,486 - Beur TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=225&flavour=ld
#EXTINF:0,487 - Berbère TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=256&flavour=sd
#EXTINF:0,488 - Berbère Jeunesse (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=936&flavour=sd
#EXTINF:0,489 - Berbère Music (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=937&flavour=sd
#EXTINF:0,491 - Al Resalah (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=922&flavour=ld
#EXTINF:0,492 - Rotana Aflam (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1094&flavour=ld
#EXTINF:0,493 - Rotana Cinema (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=920&flavour=ld
#EXTINF:0,494 - Rotana Clip (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=923&flavour=ld
#EXTINF:0,496 - Rotana Masriya (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1095&flavour=ld
#EXTINF:0,497 - Rotana Music Channel (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=924&flavour=ld
#EXTINF:0,498 - Rotana Classic (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=925&flavour=ld
#EXTINF:0,499 - Trace Naija (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1175&flavour=ld
#EXTINF:0,500 - Trace Mziki (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1176&flavour=ld
#EXTINF:0,502 - TV Polonia (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=278&flavour=sd
#EXTINF:0,503 - TVN 24 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=794&flavour=sd
#EXTINF:0,504 - ITVN (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=795&flavour=sd
#EXTINF:0,507 - VTC 10 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1225&flavour=ld
#EXTINF:0,508 - VTV1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1226&flavour=ld
#EXTINF:0,509 - VTV3 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1227&flavour=ld
#EXTINF:0,510 - HTV9 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1228&flavour=ld
#EXTINF:0,514 - Arirang (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=894&flavour=ld
#EXTINF:0,515 - TV Romania (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=318&flavour=sd
#EXTINF:0,516 - Pro TV Int. (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=961&flavour=ld
#EXTINF:0,518 - B4U Music (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=904&flavour=ld
#EXTINF:0,519 - Canal Cocina (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1376
#EXTINF:0,520 - Decasa (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1377
#EXTINF:0,521 - Somos (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1378
#EXTINF:0,522 - Atres Cinema (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1379
#EXTINF:0,523 - Antena 3 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1101
#EXTINF:0,524 - Atres Series (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1102
#EXTINF:0,525 - Sol Musica (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1103
#EXTINF:0,526 - TV3 Cataluna (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1104&flavour=ld
#EXTINF:0,527 - Galicia TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1105&flavour=ld
#EXTINF:0,528 - ETB Sat (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=371&flavour=ld
#EXTINF:0,529 - Star TVE HD (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1293
#EXTINF:0,531 - Telesur (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=729&flavour=sd
#EXTINF:0,532 - Ritmoson Latino (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=407&flavour=sd
#EXTINF:0,533 - De pelicula (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=408&flavour=sd
#EXTINF:0,534 - TL Novelas (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=409&flavour=sd
#EXTINF:0,535 - Canal de las Estrellas (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=410&flavour=sd
#EXTINF:0,536 - Telehit (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=411&flavour=sd
#EXTINF:0,537 - TVE I (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=306&flavour=sd
#EXTINF:0,538 - Canal 24 Horas (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=307&flavour=sd
#EXTINF:0,542 - Antenna 1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=771&flavour=sd
#EXTINF:0,543 - Rai Uno (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=309&flavour=sd
#EXTINF:0,544 - Rai Due (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=314&flavour=sd
#EXTINF:0,545 - Rai Tre (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=315&flavour=sd
#EXTINF:0,546 - Mediaset Italia (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=839&flavour=ld
#EXTINF:0,550 - Numidia TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1164&flavour=ld
#EXTINF:0,552 - Tamazight TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1138&flavour=ld
#EXTINF:0,553 - Al Magharibia (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1142&flavour=ld
#EXTINF:0,554 - IMED TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=838&flavour=ld
#EXTINF:0,555 - Ennahar (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1070&flavour=ld
#EXTINF:0,557 - Ulusal Kanal (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=914&flavour=ld
#EXTINF:0,558 - Arriyadia (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=908&flavour=ld
#EXTINF:0,559 - Canal Atlas (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1139&flavour=ld
#EXTINF:0,564 - 2M Maroc (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=272&flavour=sd
#EXTINF:0,565 - TVM Europe (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=273&flavour=sd
#EXTINF:0,566 - El Hiwar Ettounsi (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1133&flavour=ld
#EXTINF:0,567 - Télévision Tunisienne (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=277&flavour=sd
#EXTINF:0,568 - Al Masriya (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=275&flavour=sd
#EXTINF:0,569 - Al Jazeera (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=276&flavour=sd
#EXTINF:0,570 - Jeem TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=412&flavour=sd
#EXTINF:0,571 - Echorouk TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1160
#EXTINF:0,572 - Echorouk News (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1366&flavour=ld
#EXTINF:0,573 - Echorouk+ (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1367&flavour=ld
#EXTINF:0,574 - El Djazairia (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1365&flavour=ld
#EXTINF:0,575 - Iqraa (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=331&flavour=sd
#EXTINF:0,576 - Nessma (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=957&flavour=ld
#EXTINF:0,577 - Samira TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1132&flavour=ld
#EXTINF:0,578 - Baraem (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=750&flavour=sd
#EXTINF:0,580 - Gulli Bil Arabi (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1372
#EXTINF:0,581 - O'TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=685&flavour=sd
#EXTINF:0,582 - Powertürk TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=489
#EXTINF:0,583 - TRT1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=490&flavour=sd
#EXTINF:0,584 - Kanal D (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=463&flavour=sd
#EXTINF:0,585 - Star TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=464&flavour=sd
#EXTINF:0,586 - TRT Cocuk (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=798&flavour=sd
#EXTINF:0,587 - SkyTurk (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=913&flavour=ld
#EXTINF:0,588 - ATV Avrupa (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=467&flavour=sd
#EXTINF:0,589 - Kanal 24 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=435&flavour=sd
#EXTINF:0,590 - TRT INT (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=369&flavour=sd
#EXTINF:0,591 - Kanal 7 INT (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=370&flavour=sd
#EXTINF:0,592 - TRT World (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1233
#EXTINF:0,594 - Hilal TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=446&flavour=sd
#EXTINF:0,595 - TV5 Turkey (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=447&flavour=sd
#EXTINF:0,596 - TGRT EU (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=465&flavour=sd
#EXTINF:0,597 - TV8 Int (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=700&flavour=sd
#EXTINF:0,600 - Halk TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1046&flavour=ld
#EXTINF:0,601 - GeoTV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=702&flavour=sd
#EXTINF:0,602 - GeoNews (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=703&flavour=sd
#EXTINF:0,603 - B4U Movies (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=704&flavour=sd
#EXTINF:0,609 - KBS (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=761&flavour=sd
#EXTINF:0,614 - The Israeli Network (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=462&flavour=sd
#EXTINF:0,616 - Arte Allemand (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=270&flavour=sd
#EXTINF:0,617 - DW-TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=312&flavour=sd
#EXTINF:0,618 - RTL (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=985&flavour=ld
#EXTINF:0,619 - RTL2 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=986&flavour=ld
#EXTINF:0,620 - Super RTL (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=987&flavour=ld
#EXTINF:0,621 - RTL Nitro (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=988&flavour=ld
#EXTINF:0,622 - Vox (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=989&flavour=ld
#EXTINF:0,623 - ProSieben (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=990&flavour=ld
#EXTINF:0,624 - Sat1 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=991&flavour=ld
#EXTINF:0,625 - NTV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=992&flavour=ld
#EXTINF:0,626 - N24 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1089&flavour=ld
#EXTINF:0,627 - SIC (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=484&flavour=sd
#EXTINF:0,628 - SIC Noticias (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1038&flavour=ld
#EXTINF:0,629 - TVI International (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1039&flavour=ld
#EXTINF:0,631 - A Bola TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1041&flavour=ld
#EXTINF:0,632 - Porto Canal (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1042&flavour=ld
#EXTINF:0,633 - Baby TV (portugais) (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1043&flavour=ld
#EXTINF:0,635 - Canal Q (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1049&flavour=ld
#EXTINF:0,636 - TVI  Ficcao (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1059&flavour=sd
#EXTINF:0,637 - RTPi (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=388&flavour=sd
#EXTINF:0,638 - TV Globo Internacional (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=722&flavour=sd
#EXTINF:0,640 - Kuwait TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=717&flavour=sd
#EXTINF:0,643 - Yemen TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=715&flavour=sd
#EXTINF:0,644 - Dubai TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=748&flavour=sd
#EXTINF:0,645 - Abu Dhabi TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=749&flavour=sd
#EXTINF:0,648 - Jordan Satellite Channel (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=718&flavour=sd
#EXTINF:0,649 - Kentron TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1159&flavour=ld
#EXTINF:0,650 - Armenia Public TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=380&flavour=sd
#EXTINF:0,651 - Armenia TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=751&flavour=sd
#EXTINF:0,652 - Shant TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=752&flavour=sd
#EXTINF:0,653 - Rossiya 24 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=792&flavour=sd
#EXTINF:0,654 - Murr TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=843&flavour=ld
#EXTINF:0,655 - NBN (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=844&flavour=ld
#EXTINF:0,656 - Future TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=845&flavour=ld
#EXTINF:0,657 - Alaraby 2 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1385
#EXTINF:0,658 - Al Jadeed (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=846&flavour=ld
#EXTINF:0,659 - Carthage + (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1363&flavour=ld
#EXTINF:0,660 - PNC Food (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1364&flavour=ld
#EXTINF:0,661 - AlMajd Holy Quran (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=807&flavour=sd
#EXTINF:0,662 - Almajd Al Hadeeth Al Nabawy (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=808&flavour=sd
#EXTINF:0,663 - AlMajd Space Channel (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=809&flavour=sd
#EXTINF:0,664 - Iqraa Int (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1035&flavour=hd
#EXTINF:0,665 - Azhari TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=817&flavour=sd
#EXTINF:0,666 - Mazzika (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=876&flavour=sd
#EXTINF:0,667 - Panorama Cinema (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1168&flavour=ld
#EXTINF:0,668 - Panorama Drama (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1169&flavour=ld
#EXTINF:0,669 - Attessia TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1369&flavour=ld
#EXTINF:0,670 - MBC Masr (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=884&flavour=ld
#EXTINF:0,671 - MBC Drama (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1091&flavour=ld
#EXTINF:0,672 - MBC 3 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=902&flavour=ld
#EXTINF:0,673 - MBC (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=334&flavour=ld
#EXTINF:0,674 - Al Arabiya (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1092&flavour=ld
#EXTINF:0,677 - Al Rawda (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1229&flavour=ld
#EXTINF:0,678 - Basma (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1230&flavour=ld
#EXTINF:0,679 - Majid (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1231&flavour=ld
#EXTINF:0,681 - JSTV 1 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=814&flavour=sd
#EXTINF:0,682 - JSTV 2 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=815&flavour=sd
#EXTINF:0,683 - Zee TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=420&flavour=sd
#EXTINF:0,684 - Zee Cinema (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=421&flavour=sd
#EXTINF:0,685 - Star Vijay (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=968&flavour=sd
#EXTINF:0,686 - Star Life OK (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=821&flavour=sd
#EXTINF:0,688 - Star plus (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=823&flavour=sd
#EXTINF:0,689 - Star gold (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=824&flavour=sd
#EXTINF:0,690 - RTV Pink Plus (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=439&flavour=sd
#EXTINF:0,691 - RTV Pink Extra (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=440&flavour=sd
#EXTINF:0,692 - Pink Film (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=889&flavour=sd
#EXTINF:0,693 - Pink Music (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=890&flavour=sd
#EXTINF:0,694 - RT Doc (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1380
#EXTINF:0,695 - Russia Today (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=726
#EXTINF:0,696 - Russia Today Espanol (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=856
#EXTINF:0,697 - Record Internacional (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=728
#EXTINF:0,698 - Russian Al Yaum (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=899&flavour=ld
#EXTINF:0,699 - Record News (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=909&flavour=ld
#EXTINF:0,700 - Karusel (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=919&flavour=ld
#EXTINF:0,701 - Channel 1 Russia (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=357&flavour=sd
#EXTINF:0,702 - CTC (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1117&flavour=ld
#EXTINF:0,703 - TNT Comedy (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1118&flavour=ld
#EXTINF:0,704 - RTR Planeta (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=317&flavour=sd
#EXTINF:0,705 - TV1000 Kino (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1119&flavour=ld
#EXTINF:0,706 - Dom Kino (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=840&flavour=ld
#EXTINF:0,707 - Muzika Pervoyo (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=841&flavour=ld
#EXTINF:0,708 - Vremya (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=842&flavour=ld
#EXTINF:0,719 - Mandarin TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1131
#EXTINF:0,720 - CGTN-Documentaire (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=948&flavour=sd
#EXTINF:0,721 - CCTV4 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=469&flavour=sd
#EXTINF:0,722 - CGTN-News (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=479&flavour=sd
#EXTINF:0,723 - CGTN F (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=480&flavour=sd
#EXTINF:0,724 - CCTV Divertissement (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=470&flavour=sd
#EXTINF:0,725 - La chaîne chinoise (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=471&flavour=sd
#EXTINF:0,726 - Beijing TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=472&flavour=sd
#EXTINF:0,727 - Shanghai Dragon TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=473&flavour=sd
#EXTINF:0,728 - La chaîne internationale de Jiangsu (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=474&flavour=sd
#EXTINF:0,729 - Hunan Satellite TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=475&flavour=sd
#EXTINF:0,730 - Great Wall Elite (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=476&flavour=sd
#EXTINF:0,731 - Zhejiang Star TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=477&flavour=sd
#EXTINF:0,732 - Guangdong Southern TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=478&flavour=sd
#EXTINF:0,733 - Phoenix Infonews (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=481&flavour=sd
#EXTINF:0,734 - Phoenix Chinese News and Entertainment (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=266&flavour=sd
#EXTINF:0,799 - NTD Television (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=912&flavour=ld
#EXTINF:0,900 - BFM Grand Lille (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=826
#EXTINF:0,901 - TV7 Bordeaux (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=268&flavour=sd
#EXTINF:0,902 - 8 Mont-Blanc (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=319&flavour=sd
#EXTINF:0,903 - TéléGrenoble (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=423&flavour=sd
#EXTINF:0,904 - vià Grand Paris (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=360&flavour=sd
#EXTINF:0,905 - ERE TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=363&flavour=sd
#EXTINF:0,906 - La Chaîne Normande (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1125&flavour=ld
#EXTINF:0,907 - Télénantes Nantes 7 (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=389&flavour=sd
#EXTINF:0,908 - TV Tours (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=493&flavour=sd
#EXTINF:0,910 - IDF 1 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=689
#EXTINF:0,911 - Locales Ile de France (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=756&flavour=sd
#EXTINF:0,912 - Alsace 20 (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=753&flavour=sd
#EXTINF:0,913 - TV78 (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=855&flavour=ld
#EXTINF:0,914 - Wéo (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=832&flavour=sd
#EXTINF:0,915 - BFM Lyon (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=267&flavour=sd
#EXTINF:0,917 - Canal 10 Guadeloupe (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=929&flavour=ld
#EXTINF:0,918 - TLC (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1360
#EXTINF:0,919 - vià30 Pays Gardois (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=880&flavour=ld
#EXTINF:0,920 - Mirabelle TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=907&flavour=ld
#EXTINF:0,921 - viàVosges (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=900&flavour=ld
#EXTINF:0,922 - vià34 Montpellier (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=930&flavour=ld
#EXTINF:0,923 - Maritima TV (standard)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=951&flavour=ld
#EXTINF:0,924 - TV Vendée (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=964&flavour=ld
#EXTINF:0,926 - BFM Grand Littoral (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1302
#EXTINF:0,927 - TVR (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1063
#EXTINF:0,928 - Tébésud (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1064
#EXTINF:0,929 - Tébéo (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1065
#EXTINF:0,930 - D!CI TV Alpes (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1361
#EXTINF:0,932 - Télé Antilles (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1084&flavour=ld
#EXTINF:0,933 - TL7 (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1108&flavour=ld
#EXTINF:0,934 - TVPI (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1107&flavour=ld
#EXTINF:0,935 - Azur TV (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1130&flavour=ld
#EXTINF:0,936 - vià66 Pays Catalan (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1235&flavour=ld
#EXTINF:0,937 - MaTélé (HD)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1165&flavour=hd
#EXTINF:0,938 - Angers TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1174
#EXTINF:0,939 - Télé Bocal (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1220&flavour=ld
#EXTINF:0,940 - D!CI TV (bas débit)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1066&flavour=ld
#EXTINF:0,941 - Wéo Picardie (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1362
#EXTINF:0,942 - Vià31 (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1303
#EXTINF:0,943 - BFM Paris (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1375
#EXTINF:0,944 - AS TV (auto)\nrtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1383
_EOF_

   sed -i "s/\\\n/\n/" ${VLC_TV_PL_FILE}
   sed -i "s/mafreebox.freebox.fr/212.27.38.253/" ${VLC_TV_PL_FILE}
   sed -i '/(TNT)/{N;d;}' ${VLC_TV_PL_FILE}
   sed -i "s/ (.*)$//" ${VLC_TV_PL_FILE}
  fi

#  mpv --loop-playlist=inf ${VLC_TV_PL_FILE}
#  vlc --aout pulse --sout "#standard{access=http,mux=ts,dst=192.168.0.8:2022}" -f -I http --http-host 127.0.0.1 --http-port 8084 --rc-unix ${IPTVVLCSOCK} ${VLC_TV_PL_FILE}
  vlc -I ncurses --extraintf oldrc --extraintf http --http-host 127.0.0.1 --http-port 8084 --rc-unix ${IPTVVLCSOCK} ${VLC_TV_PL_FILE}
 }



#########################################################


 iptvvlcaudiotrack () { if test $# = 0; then (echo atrack | nc -N -U ${IPTVVLCSOCK}) ; else (echo atrack $1 | nc -N -U  ${IPTVVLCSOCK}) > /dev/null 2>&1 ; fi ; }

 iptvvlcsubtitletrack () { if test $# = 0; then (echo strack | nc -N -U  ${IPTVVLCSOCK}) ; else (echo strack $1 | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; fi ; }

 iptvvlcvolume () { (echo volume $1 | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcvoldown () { (echo voldown 1 | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcvolup () { (echo volup 1 | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcfullscreen () { (echo f | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcprev () { (echo prev | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcnext () { (echo next | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcshutdown () { (echo shutdown | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcstop () { (echo stop | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcplay () { (echo play | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1 ; }

 iptvvlcinfo () { echo info | nc -N -U ${IPTVVLCSOCK} ; }

 iptvvlcstatus () { echo status | nc -N -U ${IPTVVLCSOCK} ; }

 iptvvlctitle () { echo get_title | nc -N -U ${IPTVVLCSOCK} ; }

 iptvvlcplaylist () { echo playlist | nc -N -U ${IPTVVLCSOCK} ; }

 iptvvlczapping () {
  (echo goto 1 | nc -N -U ${IPTVVLCSOCK}) > /dev/null 2>&1
  IPTVVLCPLCOUNT=$(echo playlist | nc -N -U ${IPTVVLCSOCK} | grep "|  - " | wc -l)
#  for (( IPTVVLCPLITEM = 0; IPTVVLCPLITEM < ${IPTVVLCPLCOUNT}; IPTVVLCPLITEM++)) ; do
  for IPTVVLCPLITEM in $(seq 1 ${IPTVVLCPLCOUNT}) ; do                                                                                              
   sleep 10
   iptvvlcnext 
  done
 }


#########################################################


 iptvmpvplaylist_func () {
  unset iptvlistarray
  unset iptvorderarray
  declare -gA iptvlistarray
  declare -ga iptvorderarray

  iptvlistarray[tf1]="rtsp://192.168.0.40/fbxdvb/stream?tsid=6&nid=8442&sid=1537&frontend=1"                 ; iptvorderarray[0]="tf1"
  iptvlistarray[f2]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=201"                   ; iptvorderarray[1]="f2"
  iptvlistarray[f3]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=202"                   ; iptvorderarray[2]="f3"
  iptvlistarray[cplus]="rtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=769&frontend=1"                ; iptvorderarray[3]="cplus"
  iptvlistarray[f5]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=203"                   ; iptvorderarray[4]="f5"
  iptvlistarray[m6]="rtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1025&frontend=1"                  ; iptvorderarray[5]="m6"
  iptvlistarray[arte]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=204"                 ; iptvorderarray[6]="arte"
  iptvlistarray[c8]="rtsp://192.168.0.40/fbxdvb/stream?tsid=2&nid=8442&sid=513&frontend=1"                   ; iptvorderarray[7]="c8"
  iptvlistarray[w9]="rtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1026&frontend=1"                  ; iptvorderarray[8]="w9"
  iptvlistarray[tmc]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=497"                  ; iptvorderarray[9]="tmc"
  iptvlistarray[tfx]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=374"                  ; iptvorderarray[10]="tfx"
  iptvlistarray[nrj12]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=375"                ; iptvorderarray[11]="nrj12"
  iptvlistarray[lcp]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=226"                  ; iptvorderarray[12]="lcp"
  iptvlistarray[f4]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=376"                   ; iptvorderarray[13]="f4"
  iptvlistarray[bfmtv]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=400"                ; iptvorderarray[14]="bfmtv"
  iptvlistarray[itele]="rtsp://192.168.0.40/fbxdvb/stream?tsid=2&nid=8442&sid=516&frontend=1"                ; iptvorderarray[15]="itele"
  iptvlistarray[cstar]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=678"                ; iptvorderarray[16]="cstar"
  iptvlistarray[gulli]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=677"                ; iptvorderarray[17]="gulli"
  iptvlistarray[fo]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=238"                   ; iptvorderarray[18]="fo"
  iptvlistarray[hd1]="rtsp://192.168.0.40/fbxdvb/stream?tsid=10&nid=8442&sid=2561&frontend=1"                ; iptvorderarray[19]="hd1"
  iptvlistarray[lequipe]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=994"              ; iptvorderarray[20]="lequipe"
  iptvlistarray[6ter]="rtsp://192.168.0.40/fbxdvb/stream?tsid=4&nid=8442&sid=1046&frontend=1"                ; iptvorderarray[21]="6ter"
  iptvlistarray[rmcstory]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=996"             ; iptvorderarray[22]="rmcstory"
  iptvlistarray[rmcdecouverte]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=997"        ; iptvorderarray[23]="rmcdecouverte"
  iptvlistarray[cherie25]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=998"             ; iptvorderarray[24]="cherie25"
  iptvlistarray[lci]="rtsp://192.168.0.40/fbxdvb/stream?tsid=3&nid=8442&sid=776&frontend=1"                  ; iptvorderarray[25]="lci"
  iptvlistarray[finfo]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1173"               ; iptvorderarray[26]="finfo"
  iptvlistarray[ppremiere]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=213&flavour=ld" ; iptvorderarray[27]="ppremiere"
  iptvlistarray[rtl9]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=210"                 ; iptvorderarray[28]="rtl9"
  iptvlistarray[gameone]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=220"              ; iptvorderarray[29]="gameone"
  iptvlistarray[ab1]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=211"                  ; iptvorderarray[30]="ab1"
  iptvlistarray[paramount]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1050"           ; iptvorderarray[31]="paramount"
  iptvlistarray[tv5m]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=206"                 ; iptvorderarray[32]="tv5m"
  iptvlistarray[alamaison]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1426"           ; iptvorderarray[33]="alamaison"
  iptvlistarray[drivein]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1295&flavour=ld"  ; iptvorderarray[34]="drivein"
  iptvlistarray[paramountdec]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=1167"        ; iptvorderarray[35]="paramountdec"
  iptvlistarray[histoire]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=235"             ; iptvorderarray[36]="histoire"
  iptvlistarray[toutelhistoire]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=250"       ; iptvorderarray[37]="toutelhistoire"
  iptvlistarray[scienceetvie]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=251"         ; iptvorderarray[38]="scienceetvie"
  iptvlistarray[cnews]="rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=679"                ; iptvorderarray[39]="cnews"

 }

 iptvmpv () {   
  export iptvcmd="mpv --msg-level=all=no --no-terminal "
  iptvmpvplaylist_func
  if [[ " ${!iptvlistarray[@]} " =~ " ${1} " ]] && [[ -n ${1} ]]; then
   echo "IPTV URL played: " ${iptvlistarray[$1]}
   ${iptvcmd:-mpv --msg-level=all=no --no-terminal } ${iptvlistarray[$1]}
  elif [[ ${1} == "all" ]]; then
   for i in "${iptvorderarray[@]}"
   do  
    IPTVLISTORDERED+=" ${iptvlistarray[$i]} "
   done
   ${iptvcmd:-mpv --msg-level=all=no --no-terminal } --loop-playlist ${IPTVLISTORDERED}
  else
   echo "Usage: ${FUNCNAME[0]} CHANNEL"
   echo "or: iptv all"
   echo "CHANNEL list:"
   echo "${!iptvlistarray[@]}" | tr " " "\n" | column
  fi
 }


#########################################################

 iptvmpvrecord () {
  if [[ $# == 1 && ${1} == "-i" ]] ; then
   read -e -p "URL to record : " IPTVRECORDURL
   read -e -p "Record duration (s): " -i 60 IPTVRECORDDURATION
  elif [[ $# == 2 ]] ; then
   IPTVRECORDURL="${1}"
   IPTVRECORDDURATION="${2}"
  else
   echo -e "Usage (duration in seconds):\n\tInteractive mode: ${FUNCNAME[0]} -i\n\tBatch mode: ${FUNCNAME[0]} URL DURATION\n"
   echo -e "Example transcoding command:\nHandBrakeCLI -e vp9 --all-audio -s 1,2,3,4,5,6,7,8,9 -i /tmp/input.ts -o /tmp/input.mkv"
   return 0
  fi

  if [[ "${IPTVRECORDURL}" =~ "://" && ${IPTVRECORDDURATION} =~ ^[0-9]+$ && ${IPTVRECORDDURATION} > 0  && ${IPTVRECORDDURATION} < 7200 ]] ; then
   IPTVRECORDOUTPUTFILE="/tmp/iptvrecord-$(echo "${IPTVRECORDURL}" | sed "s/:\|\/\|&\|\?\|\=\|\./_/g")-$(/bin/date +%Y%m%d_%Hh%Mm%S).ts"
   mpv "${IPTVRECORDURL}" --stream-record="${IPTVRECORDOUTPUTFILE}" -length="${IPTVRECORDDURATION}" --vo=null --ao=null
  else
   echo "Failed. Wrong URL or duration."
  fi
 }


#########################################################


 iptvfboxplgenauto_func () {   
  FREEBOXPLAUTOFILE="/tmp/freeboxplauto.m3u"
  if [ ! -f ${FREEBOXPLAUTOFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(auto\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPLAUTOFILE}
  fi
 }

 iptvfboxplgenstandard_func () {   
  FREEBOXPLSTANDARDFILE="/tmp/freeboxplstandard.m3u"
  if [ ! -f ${FREEBOXPLSTANDARDFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(standard\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPLSTANDARDFILE}
  fi
 }

 iptvfboxplgenhd_func () {   
  FREEBOXPLHDFILE="/tmp/freeboxplhd.m3u"
  if [ ! -f ${FREEBOXPLHDFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(HD\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPLHDFILE}
  fi
 }

 iptvfboxplgen4k_func () {   
  FREEBOXPL4KFILE="/tmp/freeboxpl4k.m3u"
  if [ ! -f ${FREEBOXPL4KFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(4K\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPL4KFILE}
  fi
 }

 iptvfboxplgenbasdebit_func () {   
  FREEBOXPLBASDEBITFILE="/tmp/freeboxplbasdebit.m3u"
  if [ ! -f ${FREEBOXPLBASDEBITFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(bas débit\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPLBASDEBITFILE}
  fi
 }

 iptvfboxplgentnt_func () {   
  FREEBOXPLTNTFILE="/tmp/freeboxpltnt.m3u"
  if [ ! -f ${FREEBOXPLTNTFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | grep -A 1 "\(TNT\)" | sed "s/mafreebox.freebox.fr/212.27.38.253/" | grep -v "^--" > ${FREEBOXPLTNTFILE}
  fi
 }

 iptvfboxplgennotnt_func () {   
  FREEBOXPLNOTNTFILE="/tmp/freeboxplnotnt.m3u"
  if [ ! -f ${FREEBOXPLNOTNTFILE} ] ; then
   curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | sed "s/mafreebox.freebox.fr/212.27.38.253/" | sed '/(TNT)/{N;d;}' > ${FREEBOXPLNOTNTFILE}
  fi
 }

 alias iptvfboxplgenall="iptvfboxplgenauto_func; iptvfboxplgen4k_func; iptvfboxplgenbasdebit_func; iptvfboxplgentnt_func; iptvfboxplgennotnt_func"

# curl http://mafreebox.freebox.fr/freeboxtv/playlist.m3u | sed "s/.*\((.*)\).*/\1/" | sort | uniq

fi
