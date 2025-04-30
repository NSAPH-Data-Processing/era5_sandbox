#!/bin/bash
#
#SBATCH -p test # partition (queue)
#SBATCH -c 12 # number of cores 
#SBATCH --mem 250GB # memory 
#SBATCH -t 0-12:00 # time (D-HH:MM)

snakemake --cores 10 -R download_raw_era5