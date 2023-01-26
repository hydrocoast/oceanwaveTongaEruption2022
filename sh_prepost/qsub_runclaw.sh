#!/bin/bash
#=== SGE options ===
#$ -q ocean.q@h103
#$ -l h_rt=120:00:00
#$ -pe mpi_fu 40
#$ -cwd
#================

#if [ -z ${MACHINEFILE} ] ; then
#    echo "define the ENV of MACHINE"
#    exit 1
#fi
#source $MACHINEFILE
export OMP_NUM_THREADS=40

make && make data && (make output | tee calc.log 2>&1 ) && \
(make juliaall | tee -a calc.log 2>&1 ) && ./creategif.sh
##make matlabplots
