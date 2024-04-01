#!/bin/bash

hostname="h100"
simdir=`basename $(pwd)`
rsync -av "miyashita@$hostname:Research/AMR/oceanwaveTongaEruption2022/$simdir/_output/gauge*.txt" _output/
rsync -av "miyashita@$hostname:Research/AMR/oceanwaveTongaEruption2022/$simdir/_plots" .
<<<<<<< Updated upstream
rsync -av "miyashita@$hostname:Research/AMR/oceanwaveTongaEruption2022/$simdir/_mat" .
=======
rsync -av "miyashita@$hostname:Research/AMR/oceanwaveTongaEruption2022/$simdir/_grd" .
>>>>>>> Stashed changes
rsync -av "miyashita@$hostname:Research/AMR/oceanwaveTongaEruption2022/$simdir/_jld2" .

