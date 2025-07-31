#!/bin/bash
#
#SBATCH -p intermediate # partition (queue)
#SBATCH -c 20 # number of cores 
#SBATCH --mem 100GB # memory 
#SBATCH -t 0-18:00 # time (D-HH:MM)

# This is a test to see if we can use pytask to download ERA5 data in parallel

pytask --parallel-backend dask -n 20