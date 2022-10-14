#!/bin/bash

#datdir=/media/miyashita/HDCZ-UT2/dataset/TongaEruption2022/Watanabe2022/Data/Fig7/eruption
datdir=/media/miyashita/HDCZ-UT2/dataset/TongaEruption2022/Watanabe2022/Data/Fig7/control

#for g in $datdir/*.nc
for g in $datdir/1001*.nc
do
    # check
    #echo $g
    gmt grdinfo -Q $g -Cn
done


