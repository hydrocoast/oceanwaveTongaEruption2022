#!/bin/bash
#=== SGE options ===
#$ -q ocean.q@h101
#$ -l h_rt=120:00:00
#$ -pe mpi_fu 40
#$ -cwd
#================

export OMP_NUM_THREADS=40

sleep 12h
#./xgeoclaw 1>calc.log 2>&1
#python /home/miyashita/Research/AMR/clawpack/clawutil/src/python/clawutil/runclaw.py xgeoclaw _output \
#       True None . False False None 1>calc.log 2>&1
#julia -e 'include("./setsave.jl"); include("./setplot.jl"); include("./setconvert.jl");'
#./creategif.sh

