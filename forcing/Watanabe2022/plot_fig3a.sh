#!/bin/bash

grd3d="Fig3a.nc4"
var="SLP_anomaly"
grd="tmp_Fig3a.nc"
#gmt grdconvert $grd3d?$var -G$grd

ps="tmp.ps"
cpt="tmp.cpt"

# decompose

# set
proj="X10/`gmt grdinfo $grd -Cn -o0,1,2,3  | awk '{print 10*($4-$3)/($2-$1)}'`"
gmt makecpt -Cpolar -T-1/1 -D > $cpt

## plot
gmt grdimage -J$proj -R$grd -Baf $grd -C$cpt -P -K > $ps
gmt pscoast -J -R -O -Wthinnest -Da -K >> $ps
gmt psscale -C$cpt -Bxaf -DJMR+w5.0/0.3+o1.5/0.0+e -J -R -O >> $ps
gmt psconvert -A -Tg $ps
