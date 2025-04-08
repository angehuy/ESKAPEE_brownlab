#!/bin/bash
#SBATCH --job-name=run_mash                  # Job name
#SBATCH --account=gts-sbrown365              # Charge account
#SBATCH -N1 -n14                             # Number of nodes (1) and cores (24)
#SBATCH --mem-per-cpu=5G                    # Memory per core (10 GB)
#SBATCH -t8:00:00                           # Duration of the job (24 hours)
#SBATCH --qos=embers                        # QOS name (same as FastANI)
#SBATCH -o mash_report-%j.out                # Output file (%j = job ID)
#SBATCH --mail-type=BEGIN,END,FAIL           # Email notifications
#SBATCH --mail-user=ahuynh41@gatech.edu      # Email for notifications

# Move to the submission directory
cd $SLURM_SUBMIT_DIR

# Load Anaconda and activate Mash environment
module load anaconda3
source ~/.bashrc
conda activate mash # conda install -c bioconda mash


reference_list=~/scratch_2/AB/reference_list.txt


# Output directory
mkdir -p ~/scratch_2/AB/

# Check if input files exist
if [[ ! -f "$reference_list" ]]; then
    echo "Error: Reference list file not found: $reference_list"
    exit 1
fi

# Setting threads (matching FastANI)
THREADS=14

echo "Running Mash with $THREADS threads"

# Commented the follow out because it is only needed to be generated once in loop
# Create a Mash sketch of the reference genomes
mash sketch -o $HOME/scratch_2/AB/reference_sketch -l "$reference_list" || {
    echo "Error: Mash sketch command failed."
    exit 1
}
