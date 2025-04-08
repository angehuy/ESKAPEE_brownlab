#!/bin/bash

# made sure to chmod u+x the reference_list.sh file

# Outer loop: Iterate through directories
#for dir in /storage/home/hcoda1/9/ahuynh41/scratch/AB/AB_dataset/ncbi_dataset/data/*/; do

for dir in /storage/home/hcoda1/9/ahuynh41/scratch_2/AB/AB_dataset/ncbi_dataset/data/*/; do
  
  # Inner loop: Iterate through files in each directory
  for file in "$dir"*; do
    echo "$file" >> ~/scratch_2/AB/reference_list.txt

  done
done



# want: /storage/home/hcoda1/9/ahuynh41/scratch/AB_dataset/ncbi_dataset/data/GCA_000008865.2/GCA_000008865.2_ASM886v2_genomic.fna


