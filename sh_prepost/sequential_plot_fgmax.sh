#!/bin/bash

nfg=`awk 'NR==7 {print $1}' _output/fgout_grids.data`

for i in `seq 1 $nfg`
do
    fgno=`awk -v i=$i 'NR==10*i {printf "%04d", $1}' _output/fgout_grids.data`
    echo "plot max fgout: $fgno ..."
    ./plot_fgmax.sh "_grd/fg${fgno}_max.grd"
done
