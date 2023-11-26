#!/usr/bin/bash

# Loop through all subdirectories and run the simulation
cd dissolCases_230329
for dir in *
do
  cd $dir
  cp etching/Zero/* etching/0
  cd ../
done

echo All Zeros copied to 0.
