#!/bin/bash
#
#SBATCH -p intermediate # partition (queue)
#SBATCH -c 6 # number of cores 
#SBATCH --cpus-per-task=36        # request >= number of workers you want
#SBATCH --mem 100GB # memory 
#SBATCH -t 1-12:00 # time (D-HH:MM)

#SBATCH --mail-type=BEGIN,END,TIME_LIMIT_80,
#SBATCH --mail-user=ttapera@hsph.harvard.edu

# This is a test to see if we can use pytask to download ERA5 data in parallel

#pytask --dry-run 
pytask --parallel-backend loky -n 36