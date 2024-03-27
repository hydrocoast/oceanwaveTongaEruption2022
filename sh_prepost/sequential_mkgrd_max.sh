#!/bin/bash

nfg=`awk 'NR==7 {print $1}' _output/fgout_grids.data`

for i in `seq 1 $nfg`
do
    fgno=`awk -v i=$i 'NR==10*i {print $1}' _output/fgout_grids.data`
    echo "grdfile for max of fgout: $fgno ..."
    ./mkgrd_max_fgout.sh $fgno
done
