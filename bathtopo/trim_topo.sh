#!/bin/bash

file_org="gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc"

# --
#W=123.6 E=124.6 S=24.0 N=25.0
# --
#W=129.0 E=130.0 S=28.0 N=29.0
# --
#W=135.0 E=136.0 S=33.0 N=34.0
# --
#W=144.0 E=145.0 S=43.5 N=44.5
# --
#W=144.0 E=146.0 S=42.5 N=43.5
# --
#W=140.0 E=142.0 S=38.0 N=40.0
# --
W=127.0 E=129.0 S=25.0 N=37.0
# --

file_cut="gebco_2022_n${N}_s${S}_w${W}_e${E}.nc"
region="$W/$E/$S/$N"

gmt grdcut $file_org -R$region -G$file_cut -V
