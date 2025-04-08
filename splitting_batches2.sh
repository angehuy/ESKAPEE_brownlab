#!/bin/bash
# Usage: ./splitting_batches.sh <input_file> <num_files>
# Script attempts to split an input_file into a specific num_files n you want. If it cannot split evenly, it will add the remaining to another subfile,
# resulting in n+1 subfiles

# ./splitting_batches2.sh filtered_clustered_genomes.txt 20

# Input file
input_file=$1
num_files=$2

output_dir="$HOME/scratch_2/AB/bakta_batches"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Total number of lines in the file
total_lines=$(wc -l < "$input_file")

# Calculate the number of lines per file
lines_per_file=$((total_lines / num_files))

# Handle remainder (the last file gets the remainder of lines)
remainder=$((total_lines % num_files))

# Split the file into 'num_files' parts
split -l $lines_per_file "$input_file" "$output_dir/$(basename "$input_file")_part"

# If there is a remainder, append it to the last part
if [ $remainder -gt 0 ]; then
  tail -n $remainder "$input_file" >> "${output_dir}/$(basename "$input_file")_part$(printf '%02d' $num_files)"
  echo "Split into $(($num_files + 1)) parts"
else
  echo "Split into $num_files parts"
fi
