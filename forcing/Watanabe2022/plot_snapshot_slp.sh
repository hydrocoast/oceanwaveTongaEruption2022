#!/bin/bash

grd="$1"

base=`basename $grd`
ps="${base//.nc/.ps}"
cpt="tmp.cpt"

# set
#proj="X10/`gmt grdinfo $grd -Cn -o0,1,2,3  | awk '{print 10*($4-$3)/($2-$1)}'`"
proj="X12/6"

if [ ! -f "$cpt" ]; then
    gmt makecpt -Cpolar -T-1/1 -D > $cpt
fi

## plot
gmt grdimage -J$proj -R$grd -Bxa90f30 -Bya30f30 $grd -C$cpt -P -K > $ps
gmt pscoast -J -R -O -Wthinnest -Da -K >> $ps
gmt psscale -C$cpt -Bxaf -DJMR+w5.0/0.3+o1.5/0.0+e -J -R -O >> $ps
gmt psconvert -A -Tg $ps
gmt psconvert -A -Tf $ps
