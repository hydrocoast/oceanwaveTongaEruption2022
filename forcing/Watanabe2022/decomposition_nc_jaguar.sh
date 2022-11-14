#!/bin/bash

dname="./jaguar"
fname="slp_jaguar5_12h.nc"
var="psl"
Nbegin=1
Nend=720
#Nend=5

fbase="slp_jaguar5_XXX.nc"

if [ ! -d $dname ]; then
    mkdir $dname
fi


for i in `seq -f %03g $Nbegin $Nend`
do
    file_decomp="$dname/${fbase//XXX/${i}}"
    gmt grdconvert $fname?$var[$i] -G$file_decomp
done

