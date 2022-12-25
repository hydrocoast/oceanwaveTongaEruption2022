#!/bin/bash

g="gebco_2022_n29.0_s24.0_w124.0_e130.0.nc"
outps="tmp.ps"

proj="X"$(gmt grdinfo $g -Cn -o0,1,2,3  | awk '{print 10"/"10*($4-$3)/($2-$1)}')

gmt grdimage $g -J$proj -R$g -Baf -Cearth -K -P > $outps
gmt psxy -J -R -Sc10 -Wthinnest -O >> $outps <<EOF
129.540 28.327
124.170 24.320
EOF

