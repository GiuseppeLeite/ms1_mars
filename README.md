## Monocyte state 1 (MS1) cells in critically ill patients with sepsis or non-infectious conditions: association with disease course and host response

This repository contains code used to perform analysis for Leite et al. "Monocyte state 1 (MS1) cells in critically ill patients with sepsis or non-infectious conditions: association with disease course and host response". Critical Care (2024).

###  Bulk data deconvolution  

We utilized CIBERSORTx (https://cibersortx.stanford.edu/) to estimate the percentage of MS1 cells from the bulk normalized gene expression matrix. To deconvolute the whole blood gene expression data, we used the cell state signature matrix generated from scRNA-seq of peripheral blood mononuclear cells as reference. This signature matrix encompasses 16 immune cell states. CIBERSORTx was performed with batch correction, quantile normalization, absolute mode, and 100 permutations (DOI: 10.1126/scitranslmed.abe9599, DOI: 10.1126/scitranslmed.abe9599). 

The results are importet to R and the pecertages of MS1 are calculted using the following code:
- Code: CIBERSORTx Results and Stacked barplot.R

###  Gene co-expression network and module analysis

Weighted gene co-expression network analysis (WGCNA)-based modular analysis was done on the microarray data comparing the three groups using the R-based Co-Expression Modules identification Tool (CEMiTool) package.
- Code: CEMiTool.R

###  SRSq
Quantitative sepsis response signature (SRSq) score – The SRSq score was computed using a 19-gene set as the extended signature. This SRSq score ranges from 0 to 1, with values close to zero indicating patients are likely to be healthy, while values near one signify a high-risk status.
- Code: https://github.com/jknightlab/SepstratifieR
  
###  Molecular degree of perturbation (MDP) score 

Molecular degree of perturbation (MDP) score – which functions as a quantitative representation of transcriptional perturbation. This score is derived by computing the average of the highest 25% gene z-scores related to expression levels between patients with sepsis and the reference group ("healthy controls").
- Code: MDP score.R
- https://bioc.ism.ac.jp/packages/3.16/bioc/html/mdp.html
