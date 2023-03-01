#/bin/bash
res="2m"
file_org="../bathtopo/gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc"
file_new="gebco_2022_n60.0_s-60.0_w110.0_e240.0_$res.nc"
gmt grdsample $file_org -G$file_new -I$res -V
