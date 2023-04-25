#!/bin/bash
for alpha_flank in 0 10 100 1000 7000 20000; do
    for alpha_single in 0 10 1e3 1e4 1e5 1e7 1e9; do
        for alpha_frag in 0 10 1e2 1e3 1e4 1e5; do
            sbatch run_alphas.sh $alpha_flank $alpha_single $alpha_frag
        done
    done
done
