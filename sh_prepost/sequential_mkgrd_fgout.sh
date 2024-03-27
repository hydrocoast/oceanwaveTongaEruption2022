#!/bin/bash

for f in _output/fg*.q*
do
    #echo $f
    echo "convert $f ..."
    ./mkgrd_fgout.sh $f
done
