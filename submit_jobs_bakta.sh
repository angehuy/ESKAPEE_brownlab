#!/bin/bash

# loops through directory and submits jobs one at a time
# nohup ./submit_jobs_bakta.sh &> submit_jobs_bakta.log &

bash splitting_batches2.sh filtered_clustered_genomes.txt 13

mkdir -p $HOME/scratch_2/AB/bakta_batches/

# Loop through accession batch files

for file in $HOME/scratch_2/AB/bakta_batches/*; do
    sbatch bakta.sh $file
done


echo "All jobs submitted."
