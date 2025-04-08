#!/bin/bash

#SBATCH --job-name=run_clustering_test                  # Job name
#SBATCH --account=gts-sbrown365              # Charge account
#SBATCH -N1 -n10                             # Number of nodes (1) and cores (24)
#SBATCH --mem-per-cpu=10G                    # Memory per core (10 GB)
#SBATCH -t8:00:00                           # Duration of the job (24 hours)
#SBATCH --qos=embers                        # QOS name (same as FastANI)
#SBATCH -o mash_report-%j.out                # Output file (%j = job ID)
#SBATCH --mail-type=BEGIN,END,FAIL           # Email notifications
#SBATCH --mail-user=ahuynh41@gatech.edu      # Email for notifications


python clusterMash.py -i ~/scratch_2/AB_allMash.tsv -t 99.5 &
python clusterMash.py -i ~/scratch_2/AB_allMash.tsv -t 99.99 &

wait

echo "Clustering tasks completed!"

