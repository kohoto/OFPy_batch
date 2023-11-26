#!/usr/bin/bash

# location of this file: dissolCases
# load python
module load GCCcore/8.3.0
module load Python/3.7.4
source $SCRATCH/python_project/venv/bin/activate

# Loop through all subdirectories and run the simulation
dissolCases_dir=$SCRATCH/dissolCases/seed2000-stdev0_025
dir=lambda7_0-0_5-stdev0_025
cd $dissolCases_dir
cd $dir
cd conductivity
eval "postProcess -func 'patchIntegrate(name=inlet, U)' -latestTime  2>&1 | tee q.out"
eval "postProcess -func 'patchAverage(name=inlet, p)' -latestTime  2>&1 | tee pin.out"
eval "postProcess -func 'patchAverage(name=outlet, p)' -latestTime  2>&1 | tee pout.out"
cd ../
# calc conductivity
python -c "from OFPy import OFPy_cond; OFPy_cond.calc_cond('$dissolCases_dir/$dir/')"
cd ../

deactivate
echo All cases have been run.
