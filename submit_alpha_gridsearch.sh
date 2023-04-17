#!/bin/bash
SLURM_FLAGS="--job-name=learnMSA --nodes=1 --ntasks=1 --cpus-per-task=8 --mem=50gb --time=72:00:00 --output=learnMSA_%j.log --partition=pinky"
data_dir="../MSA-HMM-Analysis/data/balifam10000"
base_dir="./alpha_gridsearch"
mode=$1
for alpha_flank in 0, 10, 100, 1000, 7000, 20000; do
    for alpha_single in 0, 10, 1e3, 1e4, 1e5, 1e7, 1e9; do
        for alpha_frag in 0, 10, 1e2, 1e3, 1e4, 1e5; do
            run_name="run_${alpha_flank}_${alpha_single}_${alpha_frag}"
            if [ "$mode" = "align" ]; then
                out_dir="${base_dir}/$run_name"
                mkdir -p ${out_dir}/alignments
                mkdir -p ${out_dir}/logs
                mkdir -p ${out_dir}/times
                while read p; do
                    filename="${p}.fasta"
                        if [ ! -f "${out_dir}/alignments/$filename" ]; then
                            learnMSA_DATA="-i ${data_dir}/train/${filename} -o ${out_dir}/alignments/$filename"
                            learnMSA_FLAGS="-n 10 --alpha_flank $alpha_flank --alpha_single $alpha_single --alpha_frag $alpha_frag"
                            sbatch $SLURM_FLAGS conda activate learnMSA && python3 ../learnMSA/learnMSA.py $learnMSA_DATA $learnMSA_FLAGS
                        fi
                done < balifam10000_no_homfam_redundance.txt 
            else
                sbatch $SLURM_FLAGS ./eval.sh $run_name
            fi
        done
    done
done