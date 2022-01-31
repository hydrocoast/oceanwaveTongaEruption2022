#!/bin/bash
make && make data && (make output |tee calc.log)
make juliaall && ./creategif.sh
make matlabplots
