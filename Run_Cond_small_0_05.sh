#!/bin/bash

# Path to the original file
sbatch_file="ClosureCondBatch.sbatch"
original_file="$SCRATCH/dissolCases/OFPy_batch/$sbatch_file"
# Array of stdev names
# stvs=("025", "05", "075")

stvs=("05")
cd "$SCRATCH/dissolCases"
# for stv in "${stvs[@]}"; do
#     for i in {0100..0125}; do
#         dir_name="seed$i-stdev0_$stv"
#         if [ -d "$dir_name" ]; then
#             # If the directory exists, run prep batch
#             ./OFPy_batch/PrepBatch $dir_name
#         fi
#     done
# done

# Loop over the directories
for stv in "${stvs[@]}"; do
    for i in {0126..0150}; do
        dir_name="seed$i-stdev0_$stv"
        echo $dir_name
        if [ -d "$dir_name" ]; then
            cd "$SCRATCH/dissolCases/$dir_name"  
            # Create a symbolic link in the directory
            # ln -s $original_file .
            sbatch $sbatch_file
            cd ../
        fi
    done
done
echo Done!!