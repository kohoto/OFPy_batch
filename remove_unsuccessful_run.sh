#!/bin/bash

# cd "$SCRATCH/dissolCases"
# # Loop over all directories in the current directory
# for batch_dir in */; do
#   cd "$batch_dir"
#   for case_dir in */; do
#     # If the directory does not contain directories named "600" and "100"
#     if [ ! -d "$case_dir/etching/600" ]; then
#         # Delete the directory
#         rm -r "$case_dir"
#         echo "removed case: $case_dir"
#     fi
#   done
#   cd ../
# done


# check if there's a case or not
cd "$SCRATCH/dissolCases"
# Loop over all directories in the current directory
for batch_dir in */; do
  if [ -z "$(find "$batch_dir" -mindepth 1 -type d)" ]; then
      echo "$batch_dir does not contain any directories."
      rm -r "$batch_dir"
  fi
done