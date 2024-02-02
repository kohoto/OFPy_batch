#!/bin/bash

cd "$SCRATCH/dissolCases"
# Loop over all directories in the current directory
for batch_dir in */; do
  cd $batch_dir
  for case_dir in */; do
    # If the directory does not contain directories named "600" and "100"
    if [ -d "$case_dir/etching/600" ]; then
    # if [ ! -d "$case_dir/etching/600" ]; then
        # Delete the directory
        # rm -r "$case_dir"
        echo $case_dir
    fi
  done
done
