#!/bin/bash

# script submits max_jobs jobs at a time until a number of total_jobs reached
# ./submit_jobs.sh &> submit_jobs.log &
# nohup ./submit_jobs.sh &> submit_jobs.log &

counter=0
total_jobs_submitted=0  # Track the total number of jobs submitted
max_jobs=4  # Number of jobs to submit per iteration (reduced to avoid hitting limits)
total_jobs=152  # Total number of jobs to submit (for testing)

# Loop through the files in the data_batches_3test directory
for file in ~/scratch_2/AB/data_batches/*; do
    # Get the base name of the current file for qlist (e.g., 'reference_list.txt_partaf' -> 'partaf')
    qlist=$(basename "$file")  
    base_name="${qlist##*_}"  # Extract the part after the last underscore

    # Submit the job with the current file name (basename for qlist)
    sbatch --export=qlist="$qlist" ~/scratch_2/mash_try_AB_dist.sh
    sleep 15  # Wait for 1 second before submitting the next job
    
    # Increment the job counter
    ((counter++))
    ((total_jobs_submitted++))  # Track total jobs submitted

    # If we've submitted the specified number of jobs, wait until they finish before submitting more
    if ((counter == max_jobs)); then
        echo "Submitted $counter jobs, waiting for completion..."
        
        # Wait for all jobs to finish before continuing (this checks the status of your jobs)
        while squeue -u $(whoami) | grep -q "$base_name"; do
            sleep 60  # Check every minute
        done
        
        # Reset the counter after submitting max_jobs
        counter=0
    fi
    
    # Stop after 500 total jobs
    if ((total_jobs_submitted == total_jobs)); then
        break
    fi
done

echo "All jobs submitted."
