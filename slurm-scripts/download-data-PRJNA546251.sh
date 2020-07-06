#!/bin/bash
#SBATCH --job-name=download-data        # Job name
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=braskey@ufl.edu     # Where to send mail	
#SBATCH --account=jkim6                 # Group providing CPU and memory resources
#SBATCH --qos=jkim6                     # QOS to run job on (investment or burst)
#SBATCH --ntasks=1                      # Number of CPU cores to use
#SBATCH --mem=1gb                       # Job memory request
#SBATCH --time=24:00:00                 # Time limit hrs:min:sec (max is 744:00:00)
#SBATCH --output=download-data_%j.log   # Standard output and error log

pwd; hostname; date

module load sra/2.10.4

echo 'Downloading arabidopsis RNA seq data'

dest=/ufrc/jkim6/share/braskey/data/PRJNA546251/

# PRJNA546251
#fasterq-dump SRR9200655 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL
#fasterq-dump SRR9200659 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL
#fasterq-dump SRR9200662 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL

fasterq-dump SRR9200665 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL_UVB_6h
#fasterq-dump SRR9200668 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL_UVB_6h
#fasterq-dump SRR9200671 -O ${dest} -e 1 -t ${dest}tmp/ # Col-0, WL_UVB_6h

fasterq-dump SRR9200675 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL
#fasterq-dump SRR9200678 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL
#fasterq-dump SRR9200681 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL

#fasterq-dump SRR9200685 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL_UVB_6h
#fasterq-dump SRR9200687 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL_UVB_6h
#fasterq-dump SRR9200691 -O ${dest} -e 1 -t ${dest}tmp/ # uvr8, WL_UVB_6h