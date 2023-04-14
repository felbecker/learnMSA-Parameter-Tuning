#!/bin/bash
#SBATCH --job-name=learnMSA      # Job name
#SBATCH --nodes=1                    # Run all processes on a single node
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=8            # Number of CPU cores per task
#SBATCH --mem=30gb                    # Job memory request
#SBATCH --time=72:00:00              # Time limit hrs:min:sec
#SBATCH --output=learnMSA_%j.log     # Standard output and error log
#SBATCH --partition=pinky

conda init bash
conda activate learnMSA

HOMFAM="../MSA-HMM-Analysis/data/homfam/train/*.fasta"

OUT_DIR="./"

mkdir -p ${OUT_DIR}alignments
mkdir -p ${OUT_DIR}logs
mkdir -p ${OUT_DIR}times

run () {
    for f in $1
    do
	filename=$(basename "$f")
	if [ ! -f "${OUT_DIR}alignments/$filename" ]; then
	    { time learnMSA -i "$f" -o "${OUT_DIR}alignments/$filename" -n 10 > "${OUT_DIR}logs/${filename%.fasta}.log" ; } 2> "${OUT_DIR}times/${filename%.fasta}.time.txt"
	fi
    done
}

run "${HOMFAM}"
