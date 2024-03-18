#!/bin/bash

file_org="amami_kikai_blend_5sec.nc"
file_cut="amami_kikai_blend_5sec_cut.nc"


W=`gmt grdinfo -Cn -o0 $file_org`
E=`gmt grdinfo -Cn -o1 $file_org`
#S=`gmt grdinfo -Cn -o2 $file_org`
S="27.0"
N=`gmt grdinfo -Cn -o3 $file_org`

region="$W/$E/$S/$N"
echo $region

gmt grdcut $file_org -R$region -G$file_cut -V
