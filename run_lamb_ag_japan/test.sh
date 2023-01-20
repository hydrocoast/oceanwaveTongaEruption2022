#!/bin/bash
if [ $# -ge 1 ] ; then
    export OMP_NUM_THREADS=$1
fi
if [ $# -ge 2 ] ; then
    cat  <<EOF > set_qsub.sh
#!/bin/bash
#=== SGE options ===
#$ -q ocean.q@$2
#$ -l h_rt=120:00:00
#$ -pe mpi_fu $1
#$ -cwd
#================
EOF
    chmod 777 set_qsub.sh
fi

