#!/bin/bash

cd "$SCRATCH/dissolCases"
# Loop over the directories
for i in {0101..0125}; do
    dir_name="seed$i-stdev0_05"
    if [ -d "$dir_name" ]; then
        cd $dir_name/lambda1_0-1_0-stdev0_05
        for pc in 0 1000 2000 3000 4000
        do
            if [ -d "conductivity$pc" ]; then
                cd conductivity$pc/0
                cp $SCRATCH/dissolCases/seed0100-stdev0_05/lambda1_0-1_0-stdev0_05/conductivity0/0/U .
                cd ../../
            fi
        done
        cd ../../
    fi
done