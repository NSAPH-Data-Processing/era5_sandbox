#!/bin/bash
#
#SBATCH -p test # partition (queue)
#SBATCH -c 2 # number of cores 
#SBATCH --mem 100GB # memory 
#SBATCH -t 0-02:00 # time (D-HH:MM)

# build docs

nbdev_prepare