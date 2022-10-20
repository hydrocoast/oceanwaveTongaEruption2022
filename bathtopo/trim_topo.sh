#!/bin/bash

file_org="gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc"
file_cut="gebco_2022_n50.0_s20.0_w120.0_e150.0.nc"
region="120/150/20/50"

gmt grdcut $file_org -R$region -G$file_cut -V
