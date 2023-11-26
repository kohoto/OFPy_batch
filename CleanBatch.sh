#!/usr/bin/bash

# environment set-up
module purge                            # ensure your working environment is clean
module load GCC/8.3.0 OpenMPI/3.1.4     # load prerequisite modules
module load OpenFOAM/v1912              # load OpenFOAM/v1912
source ${FOAM_BASH}                     # set up OpenFOAM environment variables


# Loop through all subdirectories and run the simulation
cd temp
for dir in */
do
  # cd ${dir}etching
  # ./Clean
  cd ${dir}conductivity
  ./Clean
  cd ../../
done

echo All cases have been cleaned.
