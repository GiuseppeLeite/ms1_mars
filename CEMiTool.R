# CEMiTool - Gene co-expression analysis 
# Giuseppe Leite
# giuseppe.gianini@unifesp.br
# Amsterdam UMC, locatie AMC, April 2023
# Center of Experimental & Molecular Medicine (CEMM)


# BiocManager::install("CEMiTool")

# Load the packages:
library(CEMiTool)
library(ggplot2)
library(gridExtra)
library(tidyverse)

# Data preparation  ------------------------------------------------------------

# Load gene expression data - same data used for CIBERSORTx
ms1_mars <- read.delim("gene_expression.txt", row.names = 1)

# Patient cluster 
sample_annot <- read.delim("sample_annot_cemmitol.txt")

sample_annot <- sample_annot %>%
  mutate(SampleName = paste0("X", SampleName))

# Change the order of the datafram to match the order of the sample_annot
column_names <- sample_annot$SampleName[sample_annot$SampleName %in% names(ms1_mars)]
ms1_mars_ordered <- ms1_mars[, column_names]

# Check if the two data frames are in the same order
identical(names(ms1_mars_ordered), sample_annot$SampleName)

# Check if the two data frames are in the same order
identical(names(ms1_mars_ordered), sample_annot_srs$SampleName)

#

ms1_genes <- read.csv("MS1.txt", sep="")

ms1_mars_ordered <- rownames_to_column(ms1_mars_ordered, var = "gene_symbol")

#filter only ms1 genes
# Identify common gene symbols
common_gene_symbols <- intersect(ms1_mars_ordered$gene_symbol, ms1_genes$gene_symbol)

# Remove common columns based on gene_symbol
ms1_mars_ordered <- ms1_mars_ordered %>%
  filter(!gene_symbol %in% common_gene_symbols)


ms1_mars_ordered <- column_to_rownames(ms1_mars_ordered, var = "gene_symbol")

# Load hallmark gene sets 

gmt_in <- read_gmt("h.all.v2023.1.Hs.symbols.gmt")

# read interactions
int_fname <- system.file("extdata", "interactions.tsv", package = "CEMiTool")
int_df <- read.delim(int_fname)

# run CEMiTool -----------------------------------------------------------------

cem <- cemitool(ms1_mars_ordered, sample_annot, gmt_in, interactions=int_df,
                filter=TRUE, filter_pval = 0.1, min_ngen = 50,
                apply_vst = FALSE, eps = 0.1,
                plot=TRUE, verbose=TRUE)

 show_plot(cem, "gsea")

# create report as html document
generate_report(cem, directory="./Report")
 
# write analysis results into files
write_files(cem, directory="./Tables", force=TRUE)

# save all plots
save_plots(cem, "all", directory="./Plots", force=TRUE)

