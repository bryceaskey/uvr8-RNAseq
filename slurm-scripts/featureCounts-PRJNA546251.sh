#!/bin/bash
#SBATCH --job-name=featureCounts-PRJNA546251        # Job name
#SBATCH --mail-type=END,FAIL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=braskey@ufl.edu                 # Where to send mail	
#SBATCH --account=jkim6                             # Group providing CPU and memory resources
#SBATCH --qos=jkim6                                 # QOS to run job on (investment or burst)
#SBATCH --ntasks=1                                  # Number of CPU cores to use
#SBATCH --mem=2gb                                   # Job memory request
#SBATCH --time=48:00:00                             # Time limit hrs:min:sec (max is 744:00:00)
#SBATCH --output=featureCounts-PRJNA546251_%j.log   # Standard output and error log

pwd; hostname; date

module load subread/2.0.0

echo 'Counting mapped reads from RNAseq data in PRJNA546251 aligned to TAIR10 reference genome'

aln=/ufrc/jkim6/share/braskey/data/PRJNA546251/HISAT2/
gff_file=/ufrc/jkim6/share/braskey/data/TAIR10/TAIR10.gff
counts=/ufrc/jkim6/share/braskey/data/PRJNA546251/featureCounts/

# Use featureCounts to measure gene expression
# SRR9200655 SRR9200659 SRR9200662 SRR9200665 SRR9200668 SRR9200671 SRR9200675 SRR9200678 SRR9200681 SRR9200685 SRR9200687 SRR9200691
for id in SRR9200658 SRR9200661 SRR9200664 SRR9200667 SRR9200670 SRR9200674 SRR9200677 SRR9200680 SRR9200683 SRR9200686 SRR9200690 SRR9200693
do
  featureCounts -T 1 -t exon -g gene_id -s 2 \
    -a ${gff_file} \
    -o ${counts}${id}_counts.txt \
    ${aln}${id}.sam
done

# Extract gene expression counts from output files
for id in SRR9200658 SRR9200661 SRR9200664 SRR9200667 SRR9200670 SRR9200674 SRR9200677 SRR9200680 SRR9200683 SRR9200686 SRR9200690 SRR9200693
do
  cut -f 1,7 ${counts}${id}_counts.txt > ${counts}just-counts-2/${id}_counts.txt
  tail -n +2 ${counts}just-counts-2/${id}_counts.txt > ${counts}just-counts-2/${id}_counts.txt.tmp && mv ${counts}just-counts-2/${id}_counts.txt.tmp ${counts}just-counts-2/${id}_counts.txt
done

# Extract gene lengths - needed to calculate RPKM, FPKM, and TPM
cut -f 1,6 ${counts}SRR9200655_counts.txt > ${counts}gene-lengths.txt
tail -n +2 ${counts}gene-lengths.txt > ${counts}gene-lengths.txt.tmp && mv ${counts}gene-lengths.txt.tmp ${counts}gene-lengths.txt