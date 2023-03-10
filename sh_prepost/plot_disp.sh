#!/bin/bash

dtopo="../dtopo/dtopo_test.grd"
proj="X6"
projZ="Z6"
#region="115/200/-55/55"
cpt="tmp.cpt"
gmt makecpt -Cturbo -D -T-400/400  > $cpt

view="30/30"

gmt begin dtopo_test pdf
    gmt grdview $dtopo -J$proj -J$projZ -C$cpt -p$view \
        -Qsi -Bafg -Bzafg+l"(m)"
gmt end

rm $cpt
