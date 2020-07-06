#!/bin/bash
#SBATCH --job-name=HISAT2-PRJNA546251       # Job name
#SBATCH --mail-type=END,FAIL                # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=braskey@ufl.edu         # Where to send mail	
#SBATCH --account=jkim6                     # Group providing CPU and memory resources
#SBATCH --qos=jkim6                         # QOS to run job on (investment or burst)
#SBATCH --ntasks=1                          # Number of CPU cores to use
#SBATCH --mem=7gb                           # Job memory request
#SBATCH --time=48:00:00                     # Time limit hrs:min:sec (max is 744:00:00)
#SBATCH --output=HISAT2-PRJNA546251_%j.log  # Standard output and error log

pwd; hostname; date

module load adapterremoval/2.2.2 hisat2/2.2.0

echo 'Trimming, filtering, and aligning selected RNAseq data in PRJNA546251 to TAIR10 reference genome'

ref=/ufrc/jkim6/share/braskey/data/TAIR10/
index=/ufrc/jkim6/share/braskey/data/TAIR10/HISAT2-index/
reads=/ufrc/jkim6/share/braskey/data/PRJNA546251/
aln=/ufrc/jkim6/share/braskey/data/PRJNA546251/HISAT2/

# Copy reference fasta into index folder, and generate index
#cp ${ref}TAIR10.fa ${index}
#hisat2-build ${index}TAIR10.fa ${index}TAIR10

# SRR9200655 SRR9200659 SRR9200662 SRR9200665 SRR9200668 SRR9200671 SRR9200675 SRR9200678 SRR9200681 SRR9200685 SRR9200687 SRR9200691
for id in SRR9200658 SRR9200661 SRR9200664 SRR9200667 SRR9200670 SRR9200674 SRR9200677 SRR9200680 SRR9200683 SRR9200686 SRR9200690 SRR9200693
do
  # Apply AdapterRemoval to remove adapter sequences and filter low quality reads
  AdapterRemoval --file1 ${reads}${id}.fastq \
    --basename ${reads}${id} --output1 ${reads}${id}_trimmed.fastq \
    --trimns --trimqualities --minlength 80

  # Apply HISAT2 to align trimmed and filtered reads to TAIR10 reference genome
  hisat2 -U ${reads}${id}_trimmed.fastq \
    -x ${index}TAIR10 \
    -S ${aln}${id}.sam
done