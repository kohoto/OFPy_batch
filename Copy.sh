#!/usr/bin/bash

# load python
module load GCCcore/8.3.0
module load Python/3.7.4
source $SCRATCH/python_project/venv/bin/activate

# Loop through all subdirectories and run the simulation
dissolCases_dir=$SCRATCH/dissolCases/
old_proj_dir=dissolCases_230327/lambda2_0-1_0-stdev0_025
new_proj_dir=no_roughness/no_roughness
# calc conductivity
python -c "from OFPy import OFPy_copy_case; OFPy_copy_case.copy_case('$dissolCases_dir', '$old_proj_dir', '$new_proj_dir')"
deactivate
