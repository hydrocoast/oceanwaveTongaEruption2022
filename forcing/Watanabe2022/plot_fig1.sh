#!/bin/bash

grd="Fig1.nc4"
var="TBB_10min"
#grd=tmp.nc
ps="tmp.ps"
cpt="tmp.cpt"

# decompose
#gmt grdconvert $grd3d?TBB_10min -G$grd

# set
proj="X10/`gmt grdinfo $grd?$var -Q -Cn -o0,1,2,3  | awk '{print 10*($4-$3)/($2-$1)}'`"
gmt makecpt -Cpolar -T-5/5 -D > $cpt

## plot
gmt grdimage -J$proj -R$grd?$var -Baf $grd?$var -C$cpt -P -K > $ps
gmt pscoast -J -R -O -Wthinnest -Da -K >> $ps
gmt psscale -C$cpt -Bxaf -DJMR+w5.0/0.3+o1.5/0.0+e -J -R -O >> $ps
gmt psconvert -A -Tg $ps
