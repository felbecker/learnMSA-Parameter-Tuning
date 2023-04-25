#!/bin/bash
export MAX_N_PID_4_TCOFFEE=4000000
run_name=$1
ref_dir="../MSA-HMM-Analysis/data/balifam10000"
while read p; do
    filename="${p}.fasta"
    predicted_aln="alpha_gridsearch/${run_name}/alignments/$filename"
    projection="alpha_gridsearch/${run_name}/alignments/${filename%.fasta}.projection.fasta"
    reference="${ref_dir}/refs/${filename%.fasta}.ref"
    id_list=$(sed -n '/^>/p' "$reference" | sed 's/^.//')
    if [ ! -f "$projection" ]
    then
        ~/bin/t_coffee -other_pg seq_reformat -in "$predicted_aln" -action +extract_seq_list "${id_list[@]}" +rm_gap > "$projection"
    fi
    sp=$(~/bin/t_coffee -other_pg aln_compare -al1 "$reference" -al2 "$projection" -compare_mode sp \
                | grep -v "seq1" | grep -v '*' | awk '{ print $4}')
    modeler=$(~/bin/t_coffee -other_pg aln_compare -al1 "$projection" -al2 "$reference" -compare_mode sp \
                                      | grep -v "seq1" | grep -v '*' | awk '{ print $4}')
    tc=$(~/bin/t_coffee -other_pg aln_compare -al1 "$reference" -al2 "$projection" -compare_mode tc \
                | grep -v "seq1" | grep -v '*' | awk '{ print $4}')
    col=$(~/bin/t_coffee -other_pg aln_compare -al1 "$reference" -al2 "$projection" -compare_mode column \
                                      | grep -v "seq1" | grep -v '*' | awk '{ print $4}')
    time_file="alpha_gridsearch/${run_name}/times/${filename%.fasta}.time.txt"
    time="$(grep real $time_file | sed -e "s/^real\t//")"
    echo "${filename%.ref} $sp $modeler $tc $col $time" >> "alpha_gridsearch/${run_name}/${run_name}.out"
done < balifam10000_no_homfam_redundance.txt 