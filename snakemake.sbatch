#!/bin/bash
#
#SBATCH -p shared # partition (queue)
#SBATCH -c 12 # number of cores 
#SBATCH --mem 90GB # memory 
#SBATCH -t 0-20:00 # time (D-HH:MM)

snakemake --cores 12