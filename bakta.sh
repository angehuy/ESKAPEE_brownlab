#!/bin/bash
#SBATCH --job-name=run_bakta                  # Job name
#SBATCH --account=gts-sbrown365              # Charge account
#SBATCH -N1 -n14                             # Number of nodes (1) and cores (14)
#SBATCH --mem-per-cpu=5G                    # Memory per core (5 GB)
#SBATCH -t50:00:00                           # Duration of the job (50 hours)
#SBATCH --qos=inferno                        # QOS name
#SBATCH -o bakta_report-%j.out                # Output file (%j = job ID)
#SBATCH --mail-type=BEGIN,END,FAIL           # Email notifications
#SBATCH --mail-user=ahuynh41@gatech.edu      # Email for notifications

# Move to the submission directory
cd $SLURM_SUBMIT_DIR

# Load Anaconda and activate the Bakta environment (if needed)
# module load anaconda3
source ~/.bashrc
# conda deactivate
# conda activate bakta
source activate bakta


# Define directories and paths
parent_dir="$HOME/scratch_2/AB/AB_dataset/ncbi_dataset/data"
outputDir="$HOME/scratch_2/clone_bakta_annotations"
dbPath="/storage/scratch1/9/ahuynh41/db"

export outputDir dbPath

# Function to run Bakta
run_bakta() {
    accession_file="$1"  # Access the file path from the command line argument

    while read -r accession; do
        # Find the .fna file corresponding to the base name
        file=$(find "$parent_dir" -type f -name "${accession}*.fna")
        local basename=$(basename "$file")  # Get the base name of the file
        echo "Processing: $basename"
        
        # Run Bakta
        bakta --db "$dbPath" --threads 14 -o "$outputDir/${basename}" --force "$file"

        # Check if Bakta ran successfully by verifying output directory exists
        if [ ! -d "$outputDir/${basename}" ]; then
            echo "ERROR: Bakta failed for $basename. Retrying..."
            retry_bakta "$file" "$basename"  # Retry function if the directory doesn't exist
        fi

    done < "$accession_file"  # Read the accession file
}

# Retry function to handle Bakta failure
retry_bakta() {
    local file=$1
    local basename=$2
    local retries=3
    local attempt=1

    # Loop for retry logic
    while [ $attempt -le $retries ]; do
        # Run Bakta
        bakta --db "$dbPath" --threads 4 -o "$outputDir/${basename}" --force "$file"

        # Check if Bakta ran successfully
        if [ -d "$outputDir/${basename}" ]; then
            echo "Successfully processed: $basename"
            break  # Exit the loop if successful
        fi

        echo "Retrying $basename... Attempt $attempt"
        
        # Increment attempt counter
        ((attempt++))
    done

    # If Bakta fails after all retries, print an error message
    if [ $attempt -gt $retries ]; then
        echo "ERROR: $basename failed after $retries attempts."
    fi
}

# Call run_bakta with the first argument passed to the script
run_bakta "$1"

# Export functions
export -f run_bakta
export -f retry_bakta



# sbatch bakta.sh /storage/home/hcoda1/9/ahuynh41/scratch_2/AB/bakta_batches/filtered_clustered_genomes.txt_part04