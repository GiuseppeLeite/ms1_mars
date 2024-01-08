## Monocyte state 1 (MS1) cells in critically ill patients with sepsis or non-infectious conditions: association with disease course and host response

This repository contains code used to perform analysis for Leite et al. "Monocyte state 1 (MS1) cells in critically ill patients with sepsis or non-infectious conditions: association with disease course and host response". Critical Care (2024).

###  Bulk data deconvolution  

We utilized CIBERSORTx (https://cibersortx.stanford.edu/) to estimate the percentage of MS1 cells from the bulk normalized gene expression matrix. To deconvolute the whole blood gene expression data, we used the cell state signature matrix generated from scRNA-seq of peripheral blood mononuclear cells as reference (REF) This signature matrix encompasses 16 immune cell states. CIBERSORTx was performed with batch correction, quantile normalization, absolute mode, and 100 permutations. 

The 
- Code: Calculate percentage_Based in CIBERSORTx Results.R

###  Gene co-expression network and module analysis

Weighted gene co-expression network analysis (WGCNA)-based modular analysis was done on the microarray data comparing the three groups using the R-based Co-Expression Modules identification Tool (CEMiTool) package.
- Code: 
