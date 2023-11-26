#!/usr/bin/bash
#SBATCH -J CondBatchSlow
#SBATCH -t 1:00:00              
#SBATCH -N 5
#SBATCH --ntasks-per-node=5
#SBATCH --mem=16G
#SBATCH -o %x.%j

#### PUT THIS FILE IN THE BATCH DIRECTORY ####

# environment set-up
module purge                            # ensure your working environment is clean
module load GCC/8.3.0 OpenMPI/3.1.4     # load prerequisite modules
module load OpenFOAM/v1912              # load OpenFOAM/v1912
source ${FOAM_BASH}                     # set up OpenFOAM environment variables
# load python
module load GCCcore/8.3.0
module load Python/3.7.4
source $SCRATCH/python_project/venv/bin/activate

# Loop through all subdirectories and run the simulation
cd $SLURM_SUBMIT_DIR # The directory the job was submitted from.

start_time=$(date +%s)
STRING="files_for_slow"
for dir in */
do
  if [[ "$dir" == *"$STRING"* ]];then
    echo files_for_slow skipped.

  else
    cd $dir
    echo Running $dir

    cp ../files_for_slow/NumFileClean conductivity # added 
    cp ../files_for_slow/U conductivity/0

     # make sure Clean file works
    sed -i -e 's/\r$//' conductivity/NumFileClean  # modifying incompatable text file format
    chmod 775 conductivity/NumFileClean  # changing permission
    # clean number directories
    ./conductivity/NumFileClean

    # close mesh
    python -c "from OFPy import OFPy_deform_mesh; OFPy_deform_mesh.prep_case('$SLURM_SUBMIT_DIR/$dir', close=True)"
 
    # make sure Run file works
    sed -i -e 's/\r$//' conductivity/PararellRun
    # run conductivity OpenFOAM
    ./conductivity/PararellRun
    rm -r conductivity/pro* # remove processor* to save disk space
    ## post processing
    cd conductivity
    eval "postProcess -func 'patchIntegrate(name=inlet, U)' -latestTime  2>&1 | tee q.out"
    eval "postProcess -func 'patchAverage(name=inlet, p)' -latestTime  2>&1 | tee pin.out"
    eval "postProcess -func 'patchAverage(name=outlet, p)' -latestTime  2>&1 | tee pout.out"
    cd ../
    ## calc conductivity
    python -c "from OFPy import OFPy_cond; OFPy_cond.calc_cond('$SLURM_SUBMIT_DIR/$dir')"
    cd ../
  fi
done
end_time=$(date +%s)
# elasped time with second resolution
elapsed=$(( end_time - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
deactivate
echo CondBatch Done.
