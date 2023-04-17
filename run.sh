#!/bin/bash
#SBATCH --job-name=learnMSA      # Job name
#SBATCH --nodes=1                    # Run all processes on a single node
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=8            # Number of CPU cores per task
#SBATCH --mem=50gb                    # Job memory request
#SBATCH --time=72:00:00              # Time limit hrs:min:sec
#SBATCH --output=learnMSA_%j.log     # Standard output and error log
#SBATCH --partition=pinky

conda init bash
conda activate learnMSA

BALIFAM10000="../MSA-HMM-Analysis/data/balifam10000/train/"

OUT_DIR="./"

mkdir -p ${OUT_DIR}alignments
mkdir -p ${OUT_DIR}logs
mkdir -p ${OUT_DIR}times

while read p; do
    filename="${p}.fasta"
    if [ ! -f "${OUT_DIR}alignments/$filename" ]; then
	{ time learnMSA -i "${BALIFAM10000}${filename}" -o "${OUT_DIR}alignments/$filename" -n 10 > "${OUT_DIR}logs/${filename%.fasta}.log" ; } 2> "${OUT_DIR}times/${filename%.fasta}.time.txt"
    fi
done < balifam10000_no_homfam_redundance.txt 
