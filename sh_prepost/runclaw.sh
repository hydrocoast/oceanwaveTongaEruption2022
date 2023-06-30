#!/bin/bash
if [ $# -ge 1 ] ; then
    export OMP_NUM_THREADS=$1
fi

make && make data && (make output | tee calc.log 2>&1 ) && \
(make juliaall | tee -a calc.log 2>&1 ) && ./creategif.sh
make matlabplots
