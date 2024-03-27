#!/bin/bash

for f in _grd/fgout00*_*.grd
do
    #echo $f
    echo "plot $f ..."
    ./plot_fgout.sh $f
done
