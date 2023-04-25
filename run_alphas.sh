#!/bin/bash
#SBATCH --job-name=learnMSA      # Job name
#SBATCH --nodes=1                    # Run all processes on a single node
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=8            # Number of CPU cores per task
#SBATCH --mem=50gb                    # Job memory request
#SBATCH --time=72:00:00              # Time limit hrs:min:sec
#SBATCH --output=slurm_outputs/learnMSA_%j.log     # Standard output and error log
#SBATCH --partition=pinky

conda init bash
conda activate learnMSA

alpha_flank=$1
alpha_single=$2
alpha_frag=$3

data_dir="../MSA-HMM-Analysis/data/balifam10000"
base_dir="./alpha_gridsearch"
run_name="run_${alpha_flank}_${alpha_single}_${alpha_frag}"
out_dir="${base_dir}/$run_name"

mkdir -p ${out_dir}/alignments
mkdir -p ${out_dir}/logs

while read p; do
    filename="${p}.fasta"
    if [ ! -f "${out_dir}/alignments/$filename" ] && [ ! -f "${out_dir}/${run_name}.out" ]; then
        python3 learnMSA/learnMSA.py -i "${data_dir}/train/${filename}" -o "${out_dir}/alignments/$filename" -n 10 --alpha_flank $alpha_flank --alpha_single $alpha_single --alpha_frag $alpha_frag > "${out_dir}/logs/${filename%.fasta}.log" ; 
    fi
done < balifam10000_no_homfam_redundance.txt 

set -e 

./eval.sh $run_name

tar czvf ${out_dir}/alignments.tar.gz ${out_dir}/alignments && rm -r ${out_dir}/alignments
tar czvf ${out_dir}/logs.tar.gz ${out_dir}/logs && rm -r ${out_dir}/logs
