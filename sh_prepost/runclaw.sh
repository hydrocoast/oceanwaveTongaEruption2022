#!/bin/bash
make && make data && (make output | tee calc.log)
(make juliaall | tee -a calc.log)  && ./creategif.sh
make matlabplots
