0 rem@ \protocol
10 rem@ \fastfor:\shortif:\datatype byte
12 rem@ \word #,i=fast,x=fast
13 rem@ \constant vic,back,paper,spron,prior,scol,xhi,irq,off,vol,mem
15 rem@ \byte a,x1,x2,y1,y2,xa,xe,ya,ye,co,cc,sx,sy,v1,h1,v2,h2,y(,ys(,co(,ts(,p,t
16 rem@ \byte p2(,sn
17 dim sc(24),co(23),x(7),y(7),xs(7),ys(7),p2(7),ts(40)
18 for i=0 to 39:ts(i)=int(sin(i*0.15707)*50+50.5):nexti
20 vic=53248:back=vic+32:paper=vic+33:     spren=vic+21:off=vic+17:irq=56333
21 xhi=vic+16:scol=vic+39:pri=vic+27:      mem=2040
22 vol=54272+24
28 gosub13000:rem vorbereitung
29 poke back,14:poke paper,14:poke spren,0
30 print"{white}{clear}{space}*** Basic-Boss TEST CC ***"
32 print"{down}Programmieren in Basic mit der"
34 print"Geschwindigkeit von Maschinensprache !"
40 print"{down}{gray}Unmoeglich? Nein!"
42 print"Dieses Programm wurde von vorne bis"
44 print"hinten in Basic programmiert."
50 print"Dann wurde es vom Basic-Boss in reine"
52 print"Maschinensprache uebersetzt."
60 print"{down}Bitte ueberzeugen Sie sich von seiner"
70 print"Geschwindigkeit !"
90 goto20000
100 print"{clear}{down*2}  So sieht es aus, wenn die Bild-"
110 print"{down}  schirmfarbe in schneller Folge"
120 print"{down}  veraendert wird:":gosub10020
130 poke irq,127:rem interrupt aus
135 poke off,0:rem bildschirm aus
150 for i=0 to60000
180 poke back,14
190 poke back,3
200 poke back,3
210 poke back,14
220 poke back,6
240 nexti
250 poke irq,129:poke off,27
253 print"{clear}{down*2} oder so:":gosub10020
265 poke irq,127:rem interrupt aus
266 poke off,0:rem bildschirm aus
270 for i=0 to 30000
271 poke back,0
272 poke back,2
273 poke back,2
274 poke back,2
275 poke back,8
276 poke back,8
277 poke back,8
280 poke back,7
281 poke back,1
282 poke back,1
283 poke back,7
284 poke back,8
285 poke back,8
286 poke back,8
287 poke back,2
288 poke back,2
289 poke back,2
290 poke back,2
291 poke back,0
295 next
300 poke irq,129:poke off,27:return
305 :
310 print"{clear}{down*2}  Wenn ein mit dem Basic-Boss"
320 print"{down}  compiliertes Basicprogramm den"
330 print"{down}  Bildschirm bearbeitet, sieht das"
340 print"{down}  so aus:"
350 gosub10020:x1=10:x2=1:y1=14:y2=4
355 gosub11000
360 i=0
370 x1=x1+33:ifx1>=40thenx1=x1-40
375 x2=x2+17:ifx2>=40thenx2=x2-40
380 y1=y1+21:ify1>=25theny1=y1-25
385 y2=y2+7 :ify2>=25theny2=y2-25
390 co=(co+1and15)
395 gosub12000
400 i=i+1
405 if i<1000 and peek(198)=0 then370
410 mu=11:gosub14000:print"{home}{down*2} oder so:"
415 gosub10020
420 gosub11000:h1=1:v1=2:h2=2:v2=1:i=0
425 x1=1:y1=2:x2=37:y2=22:cc=1
430 if x1 =0  then h1=-h1
440 if x2<=1  then h2=-h2
450 if y1 =0  then v1=-v1
460 if y2 =0  then v2=-v2
470 if x1 =39 then h1=-h1
480 if x2>=38 then h2=-h2
490 if y1 =24 then v1=-v1
500 if y2 =24 then v2=-v2
510 x1=x1+h1:x2=x2+h2
520 y1=y1+v1:y2=y2+v2
525 co=co(cc):cc=cc+1:ifcc>23thencc=0
530 gosub12000
540 i=i+1:ifi<1000andpeek(198)=0then430
550 mu=500:gosub14000:return
560 :
570 print"{clear}{195}{196}{197}{198}Nun huepfen ein paar Sprites ueber"
580 print"{down}den Bildschirm. Allerdings ergibt sich"
590 print"{down}hier ein Problem: Das Programm ist"
600 print"{down}zu schnell. Es muss also gebremst"
605 print"{down}werden:":goto1000
610 :
620 for i=0 to 7
630 poke mem+i,13
640 poke scol+i,i+1
645 x(i)=20+int(rnd(1)*250)
647 xs(i)=i+2
650 next i
660 poke pri,0:poke spren,255
662 a=0:c=0
665 :
670 for i=0 to 7
690 if x(i)and256 then poke xhi,peek(xhi) or p2(i):goto710
700 poke xhi,peek(xhi)and (255-p2(i))
710 poke vic+i+i,x(i)and255
715 poke vic+1+i+i,y(i)
720 x(i)=x(i)+xs(i)
725 p=int(x(i)/(3+i))
726 if p>39 then p=p-40:goto 726
727 t=i:if t>5 then t=5
730 y(i)=43+i*20+int(ts(p)/(8-t))
740 if x(i)>320 then x(i)=640-x(i):xs(i)=-xs(i):gosub950
750 if x(i)<24 then x(i)=48-x(i):xs(i)=-xs(i):gosub950
800 rem beschleunigung x und y
810 if a<3 then 880
820 rem xs(i)=xs(i)+1:ys(i)=ys(i)+1
880 next i
882 ifa=3 then a=0
883 a=a+1
885 print"{cyan}{239}{114}{102}{99}{100}{101}{247}{101}{100}{99}{102}{114}{239}";
886 rem auf rasterstrahl warten
887 if b then if (peek(53248+17)and128)=0 then 887
890 if peek(198)=0 then 670
900 poke198,0:  return
950 poke vol,sn:sn=15-sn:return
990 end
999 :
1000 gosub10600:b=0:gosub610
1010 print"{down*2}jetzt ist es gebremst und wird"
1020 print"{down*2}mit dem Rasterstrahl synchronisiert."
1030 gosub10600
1050 b=-1:gosub610
1090 return
9999 :
10000 ti$="000000":goto10100
10010 ti$="000030":goto10100
10020 ti$="000035":goto10100
10100 gosub10600:goto10500
10500 poke198,0
10510 get a$:ifa$=""andti$<"000040"then10510
10520 return
10600 print"{down*3}{space*12}- Taste -":return
10998 :
11000 fori=1024to2023:pokei,160:next
11010 return
11997 :
11998 rem rechteck zeichnen mit farbe   (x1,y1,x2,y2,ch,co)
11999 rem (x1,y1,x2,y2,ch,co)
12000 if x2>=x1 then xa=x1:xe=x2:goto12002
12001 xa=x2:xe=x1
12002 if y2>=y1 then ya=y1:ye=y2:goto12050
12003 ya=y2:ye=y1
12050 for y=sc(ya) to sc(ye) step 40
12060 for x=y+xa to y+xe
12070 poke x,co:next x,y
12090 return
12998 :
12999 rem multiplikationstabelle
13000 for i=0 to 24:sc(i)=55296+i*40:next
13010 rem farben einlesen
13020 for a=0 to 23:read co(a):next
13030 mp=0
13040 for a=0 to 7:p2(a)=2^a:next
13050 for i=832 to 832+62
13060 read a:poke i,a:next i
13090 return
13499 rem farbdaten
13500 data 0,6,14,3,1,3,14,6,0,2,8,7,1,7,8,2,0,11,5,13,1,13,5,11
13599 rem spritedaten
13600 data   0,255,  0,  3,255,192, 15
13601 data 255,240, 31,255,248, 63,255
13602 data 252,127,255,254,127,255,254
13603 data 255,255,255,255,255,255,255
13604 data 255,255,255,255,255,255,255
13605 data 255,255,255,255,255,255,255
13606 data 127,255,254,127,255,254, 63
13607 data 255,252, 31,255,248, 15,255
13608 data 240,  3,255,192,  0,255,  0
13998 :
13999 rem bildschirm loeschen (mu)
14000 i=1024:a=21
14010 for a=1to5:next a
14020 pokei,32:i=i+mu
14030 ifi>=2045theni=i-1021
14040 ifi<>1024then14010
14050 return
20000 :
20010 print"{down}{right*2}Waehlen Sie:"
20020 print"{down}   1...Bildschirmdemo"
20030 print"   2...Spritedemo"
20040 print"   3...Hintergrunddemo"
20050 print"   4...Noch was"
20090 print"{down*2}(Thilo Herrmann, 1988)"
20092 :
20094 :
20100 ti$="000000":gosub10500
20110 if a$>="1" and a$<="4" then mp=val(a$):goto20130
20120 if a$<>""then20100
20125 mp=mp+1:if mp>4 then mp=1
20130 on mp gosub 310,570,100,21000
20140 goto29
21000 print"{clear}{down*2}Sie sollten zum Vergleich mal die"
21010 print"Basic-Version dieses Programmsady."
21015 print"ablaufen lassen !"
21020 print"{down}Das Basicprogramm zeigt auch, dass"
21030 print"der Programmierer alle Moeglichkeiten"
21040 print"von Basic ausreizen kann, ohne dass er"
21050 print"unnoetig eingeschraenkt wird."
21060 print"{down}Denn ausser solchen Bildschirm-"
21070 print"spielereien kann man auch ernstere"
21080 print"Anwendungen programmieren, da der"
21090 print"Basic-Boss z.B. eine wesentlich"
21100 print"leistungsfaehigere Stringverwaltung"
21110 print"besitzt als der Basicinterpreter. Darum"
21120 print"ist nun auch die Garbage-Collection"
21130 print"um einiges schneller.":gosub10000
21140 print"{clear}Was das heisst, werden Sie merken,"
21150 print"wenn Sie folgendes Programm ablaufen"
21160 print"lassen:{down}"
21170 print"10 dim a$(2000)"
21180 print"20 for i=1 to 2000"
21190 print"30 a$(i)=chr$(65):next i"
21200 print"40 ti$="000000":print"chr$(34)"frei"chr$(34)"fre(0);ti/60"
21210 print"{down}Allein der FRE-Befehl benoetigt ca."
21220 print"339 Sekunden, da er eine Garbage-"
21230 print"Collection ausloest."
21240 print"{down}Das gleiche Programm koennen Sie nun"
21250 print"in der compilierten Version starten: ":gosub10000
21260 print"{clear}{down*2} gestartet..."
21300 dim a$(2000)
21310 for i=1 to 2000
21320 a$(i)=chr$(65):next i
21330 ti$="000000":print"frei"fre(0);ti/60
21335 print"{down*2}Damit ist die Garbage-Collection"
21336 print"{down}in diesem Fall etwa 680 mal schneller !"
21340 gosub10010
21400 print"{clear}{down*2}Die Leistungsdaten des Basic-Boss:"
21410 print"{down}- kurze Compilate"
21420 print"- optimierter und effizienter Code"
21430 print"- sehr schnelle Variablentypen"
21440 print"- extrem kurze Compilierzeiten"
21450 print"- eine hochflexible Compilerarchitektur"
21460 print"- 62 KByte Basicspeicher"
21470 print"- eine schnelle FOR-NEXT-Schleife"
21480 print"- gepackte und schnelle Daten bei DATA"
21490 print"- stark beschleunigte Arrays"
21500 print"- beliebig lange Variablennamen"
21510 print"- genaue deutsche Fehlermeldungen"
21520 print"- Erzeugung echten Maschinencodes"
21525 print"- kein Kopierschutz"
21530 print"{down*2} und noch einiges mehr..."
21540 gosub10000
21550 print"{clear}{down*3} Ich bin jedem dankbar, der dieses"
21560 print" {down}Demoprogramm weiterverbreitet."
21570 goto10000
