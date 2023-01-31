#!/bin/bash

simdir=`basename $(pwd)`
rsync -av "miyashita@h100:Research/AMR/oceanwaveTongaEruption2022/$simdir/_output/gauge*.txt" _output/

