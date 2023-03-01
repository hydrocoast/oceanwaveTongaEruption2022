#!/bin/bash

dir_presgrd="../forcing/lamb_grd"
proj="X8.5/11"
region="115/200/-55/55"
cpt="tmp.cpt"
gmt makecpt -Cpolar -T-1/1 -D > $cpt

cat << EOF > lonlat_presobs.dat
139.8047 33.1303 Hachijojima
129.4977 28.3991 Naze
EOF


for grd in $dir_presgrd/*min.grd 
do
    #echo $grd
    base=`basename $grd`
    pref=${base//min.grd/}
    #echo $pref
    min=${pref#*_}
    #echo $min

    gmt begin $pref pdf
    gmt grdimage $grd -J$proj -R$region -Ba30f15 -C$cpt
    gmt coast -Wthinnest,gray30 -Dl
    gmt colorbar -C$cpt -Bxa0.5f0.5 -By+lhPa -DJMR+w10.0/0.3+o0.7/0.0+e 
    gmt text -F+f16p,0,black+jTR << EOF
    195 45 $min min
EOF
    gmt plot -Gdarkgreen -Sc0.15 -W0.2p lonlat_presobs.dat
    gmt text -F+f10p,0,darkgreen+jTC -Dj0/0.12 lonlat_presobs.dat
    gmt end
done

rm $cpt
