## Characterizing and Predicting the Niche-Specific Genomic Features of ESKAPEE Pathogens

In this project, I am designing machine learning models that predict ecological niches based on genomic data and identifying conserved ESKAPEE genes related to pathogenicity based on niche localization. 


## **Current progress that repo reflects**
* Processed genomic metadata retrieved from NCBI GenBank and assessed genome quality metrics, including CheckM contamination, completeness, number of contigs, and N50 contig size
* Completed feature creation by categorizing niches based on a combination of host disease and isolation source metadata
* Made supplementary plots of genome quality and niche proportions

## **Commands (for personal reference)**
```
- QA_11_7.rmd to get the AB txt file
   # Used genbank metadata to categorize samples into niches and did quality filtering (completion & contamination)

- To download genomic info from a txt file
    conda activate ncbi-datasets
    datasets download genome accession --inputfile ~/scratch/AB/ABgenomesToDownload_new.txt --dehydrated --filename ~/scratch/AB/AB.zip
    unzip ~/scratch/AB/AB.zip -d ~/scratch/AB/AB_dataset
    datasets rehydrate --directory ~/scratch/AB/AB_dataset/

- Mash reference list: Create a text file with the filenames of all genomes in directory called reference_list.txt
    ./reference_list.sh

- Mash query list: Create batch text files (3,925 genomes --> 27 genomes per batch file)
    ~/scratch_2/splitting_batches.sh <input_file> <num_files>
    ~/scratch_2/splitting_batches.sh ~/scratch_2/AB/reference_list.txt 146

- Pairwise comparisons with Mash
    sbatch mash_try_AB_sketch.sh
    ./submit_jobs.sh &> submit_jobs.log &

- Clustering with custom script
  # combine all files in mash_output into one tsv file
  cat $(ls ~/scratch_2/AB/mash_output/) > ~/scratch_2/AB_allMash.tsv
  bash clusterMash.sh # run clustering script

- Visualizing the clusters with sankey and proportion plots
  # run clusterMash2.ipynb

- Running bakta
  nohup ./submit_jobs.sh &> submit_jobs.log &
```
