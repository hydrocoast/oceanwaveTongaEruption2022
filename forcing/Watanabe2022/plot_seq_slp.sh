#!/bin/bash

cpt="tmp.cpt"
gmt makecpt -Cpolar -T-1/1 -D > $cpt

figdir="fig_slp"
if [ ! -d $figdir ]; then
    mkdir $figdir
fi

Nbegin=1
Nend=720

### plot all
#for f in jaguar/*.nc
#do 
for i in `seq -f %03g $Nbegin $Nend`
do
    f="jaguar/slp_jaguar5_$i.nc"
    echo $f
    ./plot_snapshot_slp.sh $f

    file_base=`basename $f`
    mv ${file_base//\.nc/\.png} $figdir/
    rm ${file_base//\.nc/\.ps}
done

rm $cpt
