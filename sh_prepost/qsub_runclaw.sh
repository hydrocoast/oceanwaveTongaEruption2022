#!/bin/bash
#=== SGE options ===
#$ -q ocean.q@h103
#$ -l h_rt=120:00:00
#$ -pe mpi_fu 40
#$ -cwd
#================

export OMP_NUM_THREADS=40

./xgeoclaw 1>calc.log 2>&1
julia -e 'include("./setsave.jl"); include("./setplot.jl"); include("./setconvert.jl");'
./creategif.sh
