#!/bin/bash

# Path to the original file
sbatch_file="All_small.sbatch"
original_file="$SCRATCH/dissolCases/OFPy_batch/$sbatch_file"

cd "$SCRATCH/dissolCases"
for i in {0200..1800}; do
    dir_name="seed$i-stdev0_1"
    if [ -d dir_name ]; then
        # If the directory exists, run prep batch
        ./OFPy_batch/PrepBatch $dir_name
    fi

done

# Loop over the directories
for i in {0200..1800}; do
    dir_name="seed$i-stdev0_1"
    if [ -d dir_name ]; then
        cd $dir_name    
        # Create a symbolic link in the directory
        # ln -s $original_file .
        sbatch $sbatch_file
        cd ../
    fi
done
