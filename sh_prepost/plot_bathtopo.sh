#!/bin/bash

output="bathtopo_gebco.ps"

#bath="../bathtopo/gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc"
bath="./gebco_2022_n60.0_s-60.0_w110.0_e240.0_1m.nc"
proj="X8.5/11"
region="115/200/-55/55"
cpt="tmptopo.cpt"
gmt makecpt -Cetopo1 > $cpt

echo "184.6067 -20.544686 Volcano" > lonlat_hungatonga.dat
cat << EOF > lonlat_DART5.dat
148.836  38.723  21418
134.968  28.912  21420
155.739  19.285  52401
153.895  11.930  52402
132.139  20.629  52404
EOF

gmt begin bath pdf
    gmt grdimage $bath -J$proj -R$region -Ba30f15 -C$cpt
    gmt coast -Wthinnest,gray30 -Dl
    gmt colorbar -C$cpt -Bxa2000f1000 -By+lm -DJMR+w10.0/0.3+o0.7/0.0 
    gmt plot -Gred -St0.3 -W0.1p lonlat_hungatonga.dat
    gmt text -F+f11p,0,red+jTC -Dj0/0.12 lonlat_hungatonga.dat
    gmt plot -Gyellow -Ss0.25 -W0.1p lonlat_DART5.dat
    gmt text -F+f11p,0,yellow+jTC -Dj0/0.12 lonlat_DART5.dat
gmt end

rm lonlat_*.dat
rm tmptopo.cpt
