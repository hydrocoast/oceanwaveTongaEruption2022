#!/bin/bash
make && make data && (make output 2>&1 | tee calc.log)
(make juliaall 2>&1 | tee -a calc.log)  && ./creategif.sh
make matlabplots
