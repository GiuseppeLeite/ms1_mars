# mdp  - Molecular Degree of Perturbation analysis

# Giuseppe Leite
# giuseppe.gianini@unifesp.br
# Amsterdam UMC, locatie AMC, April 2023
# Center of Experimental & Molecular Medicine (CEMM)

# Load the packages:

library(mdp)
library(tidyverse)
library(rstatix)
library(gtsummary)
library(ggplot2)
library(ggpubr)

# Data preparation  ------------------------------------------------------------

# Load gene expression data - same data used for CIBERSORTx
ms1_mars <- read.delim("gene_expression.txt", row.names = 1)

# Patient cluster 
sample_annot_mdp <- read.delim("sample_annot_mdp.txt")

sample_annot_mdp <- sample_annot_mdp %>%
  mutate(SampleName = paste0("X", SampleName))

# Change the order of the data frame to match the order of the sample_annot_mdp
column_names <- sample_annot_mdp$SampleName[sample_annot_mdp$SampleName %in% names(ms1_mars)]
ms1_mars_ordered <- ms1_mars[, column_names]

# Check if the two data frames are in the same order
identical(names(ms1_mars_ordered), sample_annot_mdp$SampleName)


colnames(sample_annot_mdp)[colnames(sample_annot_mdp) == "SampleName"] <- "Sample"

# Using all genes ----------------------------------------------------------------
mdp.results <- mdp(data=ms1_mars_ordered, pdata=sample_annot_mdp, control_lab = "HVs")

gene_scores <- mdp.results$gene_scores
gene_freq <- mdp.results$gene_freq
sample_scores_list <- mdp.results$sample_scores

sample_scores_all <- sample_scores_list[["allgenes"]]
sample_plot(sample_scores_all,control_lab = "HVs", title="All genes")

# # write analysis results into files
write.table(sample_scores_all, file="MDP_sample_scores_all_genes.txt", sep="\t", quote=FALSE)

# Using only Perturbed genes ---------------------------------------------------
# The mdp ranks genes according to the difference between their gene score in the test versus the control samples. 
# The fraction_genes option for the mdp function allows you to control what top fraction of these ranked genes will count as the perturbed_genes. 

perturbed_genes <- mdp.results$perturbed_genes

sample_scores_perturbed_genes <- sample_scores_list[["perturbedgenes"]]
sample_plot(sample_scores_perturbed_genes,control_lab = "HVs", title="All genes")

# write analysis results into files
write.table(sample_scores_perturbed_genes, file="MDP_sample_scores_sample_scores_perturbed_genes.txt", sep="\t", quote=FALSE)
