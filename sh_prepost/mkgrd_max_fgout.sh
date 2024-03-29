#!/bin/bash

if [ $# -lt 1 ]; then
   echo "Invalid number of argument."
   echo "usage: $0 [fg number]" 
   exit 2
fi

fgno="$1"
fgno_str=`echo $fgno | awk '{printf "%04d", $1}'`

maxgrd="fg${fgno_str}_max.grd"

fname0=`ls -1 _grd/fgout${fgno_str}_*.grd | head -n 1`
#echo $fname0

cp -p $fname0 $maxgrd


for g in _grd/fgout${fgno_str}_*.grd
do
    #echo $g
    gmt grdmath $maxgrd $g MAX = $maxgrd
done

mv $maxgrd "_grd/"
