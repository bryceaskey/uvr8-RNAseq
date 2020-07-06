# Differential gene expression analysis using edgeR package
# Goal - perform pairwise comparisons of expression data for Col-0 and hy5 genotypes

# Install and load packages, and set working directory
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("edgeR")

library(edgeR)

setwd("C:/Users/Bryce/Documents/uvr8-RNAseq/")

# Load sample metadata
metadata <- read.csv("data/metadata.csv")
metadata$genotype <- factor(metadata$genotype)
metadata$treatment <- factor(metadata$treatment)

# Load gene expression data
expressionData <- readDGE(paste(getwd(), "/data/featureCounts/set2/", dir("data/featureCounts/set2/"), sep=""),
  labels=sapply(strsplit(dir("data/featureCounts/set2/"), "_"), `[`, 1),
  group=c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4))
expressionData$genes <- read.delim("data/gene-lengths.txt", row.names=1)
print(paste("# of reads before filtering:", nrow(expressionData)))

# Only keep genes with cpm > 1 in at least two samples
keep <- rowSums(cpm(expressionData) > 1) >= 2
expressionData <- expressionData[keep, ]
expressionData$samples$lib.size <- colSums(expressionData$counts)
print(paste("# of reads after filtering:", nrow(expressionData)))

# Normalize for library size
expressionData <- calcNormFactors(expressionData)

# Create MDS plot to verify integrity of RNAseq data
plotMDS(expressionData, top=500, gene.selection="common", method="bcv", col=c(rep("black", 3), rep("red", 3), rep("blue", 3), rep("green", 3)))

# Calculate RPKM values, export as a .csv
rpkm <- rpkm(expressionData$counts, gene.length=expressionData$genes$Length, normalized.lib.sizes=TRUE, log=FALSE)
write.csv(rpkm, file="data/rpkm.csv")