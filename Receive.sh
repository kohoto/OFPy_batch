#!/bin/sh
proj=dissolFrac_testRoughSurfGen18

grace_ep=649715d4-55f5-11eb-87b9-02187389bd35
mine_ep=6b33a6ee-ca76-11ed-8cfb-f9fa098153fc

# While we're at it, we'll set our source and destination directories to prevent typos and errors.
mkdir $proj
run1_path=/scratch/user/tohoko.tj/dissolCases/$proj/
mine_path=/~/$proj/

# Check Endpoint Activation
# globus endpoint is-activated $theta_ep 

# List Source Files
# The `globus ls` works a lot like `ls` on a POSIX command line and we can use the `--filter` option to save us from parsing the full list.
# globus ls --filter 'inp' $grace_ep:$run1_path > run1_files.txt
globus ls -a $grace_ep:$run1_path > transfered_files.txt
# The batch transfer expects a list of source files and their corresponding destination filenames. In this case, those are the same and our files will have lines like:


for i in `cat transfered_files.txt`
  do
      echo "$i $i"
  done > log.Receive

# Batch Submit the Transfers

globus transfer --batch $grace_ep:$run1_path $mine_ep:$mine_path < log.Receive
