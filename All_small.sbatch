#!/usr/bin/bash
#SBATCH -J EtchingBatch
#SBATCH -t 2:00:00              
#SBATCH -N 5
#SBATCH --ntasks-per-node=5
#SBATCH --mem=17G
#SBATCH -o %x_%j.log

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

#nx = 5
#ny = 5
# Loop through all subdirectories and run the simulation
echo $SLURM_SUBMIT_DIR
cd $SLURM_SUBMIT_DIR # The directory the job was submitted from.
for dir in */
do
  cd $dir
  sed -i -e 's/\r$//' etching/PararellRun
  ./etching/PararellRun 5 5
  rm -r etching/pro* # remove processor* to save disk space

  # start conductivity
    dir_wo_slash=${dir::-1}
  echo Running $dir_wo_slash

  # generate closed mesh for 0, 1000, 2000, 3000, and 4000 psi closure stress
  python -c "from OFPy import OFPy_deform_mesh; OFPy_deform_mesh.prep_case('$SLURM_SUBMIT_DIR/$dir_wo_slash', close=True)"
  for pc in 0 1000 2000 3000 4000
  do
    cp ../../files_for_slow/U conductivity$pc/0
    cd conductivity$pc
    eval "checkMesh -allGeometry -allTopology"
    # make sure Run file works
    sed -i -e 's/\r$//' PararellRun
    chmod 775 PararellRun
    # run conductivity OpenFOAM
    ./PararellRun
    rm -r pro* # remove processor* to save disk space
    ## post processing
    
    eval "postProcess -func 'patchIntegrate(name=inlet, U)' -latestTime  2>&1 | tee q.out"
    eval "postProcess -func 'patchAverage(name=inlet, p)' -latestTime  2>&1 | tee pin.out"
    eval "postProcess -func 'patchAverage(name=outlet, p)' -latestTime  2>&1 | tee pout.out"
    cd ../
  done

  ## calc conductivity
  python -c "from OFPy import OFPy_cond; OFPy_cond.calc_cond('$SLURM_SUBMIT_DIR/$dir_wo_slash')"

  cd ../
done

end_time=$(date +%s)
# elasped time with second resolution
elapsed=$(( end_time - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
deactivate

echo All cases have been run!