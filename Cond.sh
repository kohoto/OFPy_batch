#!/usr/bin/bash

# load python
module load GCCcore/8.3.0
module load Python/3.7.4
source $SCRATCH/python_project/venv/bin/activate

# Loop through all subdirectories and run the simulation
# dissolCases_dir=$SCRATCH/dissolCases/dissolCases_230327
dissolCases_dir=$SCRATCH/dissolCases/try_cond_again

cd $dissolCases_dir
start_time=$(date +%s)
for dir in */
do
  cd $dir
  cd conductivity
  eval "postProcess -func 'patchIntegrate(name=inlet, U)' -latestTime  2>&1 | tee q.out"
  eval "postProcess -func 'patchAverage(name=inlet, p)' -latestTime  2>&1 | tee pin.out"
  eval "postProcess -func 'patchAverage(name=outlet, p)' -latestTime  2>&1 | tee pout.out"
  cd ../
  # calc conductivity
  python -c "from OFPy import OFPy_cond; OFPy_cond.calc_cond('$dissolCases_dir/$dir')"
  cd ../
done
end_time=$(date +%s)
# elasped time with second resolution
elapsed=$((end_time - start_time))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
deactivate
echo All cases have been run.
