#!/bin/bash
#SBATCH --job-name=dask-rapids
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:10:00
#SBATCH --output=dask-worker-%j.out

# Load CUDA module (ensure version matches your RAPIDS install)
module load CUDA/11.7.0

# Setup Conda
export CONDA_ENV=/mnt/vstor/SOM_GENE_BEG33/mamba/miniforge3
source $CONDA_ENV/etc/profile.d/conda.sh
conda activate rapids
dask scheduler --scheduler-file scheduler.json &
sleep 5
dask-cuda-worker --scheduler-file=scheduler.json --no-affinity --rmm-pool-size=12GB &

sleep 10

# Run your Python script
python /home/hxk728/git/fossil-c/sandbox/a.py

# Cleanup
pkill -f dask-scheduler
pkill -f dask-cuda-worker   
