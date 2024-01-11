# Gene Set Enrichment Analysis (GSEA)

# Giuseppe Leite
# giuseppe.gianini@unifesp.br
# Amsterdam UMC, locatie AMC, May 2023
# Center of Experimental & Molecular Medicine (CEMM)

# Load necessary libraries
library(psych)
library(reshape2)
library(ggplot2)
library(ggrepel)
library(tidyverse)
library(fgsea)
library(stats)
library(msigdbr)
set.seed(123)

# Read the data file
data <- read.delim("DEGs.txt")

# Extract the ranks for enrichment analysis
ranks <- data %>%
  select(Gene_name, t)

# Sort the ranks in descending order
ranks <- ranks[order(-ranks$t, decreasing = TRUE), ]

# Convert ranks to a named vector
ranks <- deframe(ranks)
head(ranks, 20)


# Define hallmark gene signature list using msigdbr
pathways.hallmark <- msigdbr(species = "Homo sapiens", category = "H") %>%
  distinct(gs_name, gene_symbol) %>%
  nest(genes = c(gene_symbol)) %>%
  mutate(genes = map(genes, compose(as_vector, unname))) %>%
  deframe()


# Perform the enrichment analysis for Hallmark gene set
fgseaRes <- fgsea(pathways = pathways.hallmark, stats = ranks, nPerm = 10000,
                  minSize = 15,
                  maxSize = 500)

# Remove the leading edge information from the results
fgseaRes$leadingEdge <- NULL


# Save the results to a file
write.table(fgseaRes, file = "gsea_results_hallmark_MSigDB.txt")

# Define reactome gene signature list using msigdbr
pathways.reactome <- msigdbr(species = "Homo sapiens", category = "C2", subcategory = "REACTOME") %>%
  distinct(gs_name, gene_symbol) %>%
  nest(genes = c(gene_symbol)) %>%
  mutate(genes = map(genes, compose(as_vector, unname))) %>%
  deframe()

# Perform the enrichment analysis for REACTOME gene set
fgseaRes <- fgsea(pathways = pathways.reactome, stats = ranks,  nperm=10000,
                  minSize = 15,
                  maxSize = 500)

# Remove the leading edge information from the results
fgseaRes$leadingEdge <- NULL

# Save the results to a file
write.table(fgseaRes, file = "gsea_results_reactome_MSigDB.txt")

# Perform the enrichment analysis for mitopathways3 gene set
fgseaRes <- fgsea(pathways = mitopathways3, stats = ranks,  nperm=10000,
                  minSize = 15,
                  maxSize = 500)

