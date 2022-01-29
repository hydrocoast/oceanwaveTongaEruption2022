#!/bin/bash

simdirname=`basename $(pwd)`
echo $simdirname
rsync -av _output miyashita@10.244.124.13:/mnt/HDD8TB/00_PhD/00_Research/AMR/hagibis/${simdirname}/
