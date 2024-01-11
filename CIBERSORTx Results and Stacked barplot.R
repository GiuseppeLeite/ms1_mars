
## Calculate percentage of each Cell_stage for each patient and Stacked barplot
# Giuseppe Leite, 
# giuseppe.gianini@unifesp.br
# Amsterdam UMC, locatie AMC, April 2023
# Center of Experimental & Molecular Medicine (CEMM)

# Load the packages:

library(tidyverse)
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
set.seed(123)

# Read Cibersortx output
CIBERSORTx_results <- read.delim("CIBERSORTx_Job11_Adjusted.txt") |> 
  select(1:17)

CIBERSORTx_cells <- CIBERSORTx_results %>%
  pivot_longer(!Mixture, names_to = "Cells", values_to = "Frequency")

# Define the number of colors you want

nb.cols <- 16
mycolors <- colorRampPalette(brewer.pal(8, "Set1"))(nb.cols)

# Stacked barchart

p1 <- ggplot(CIBERSORTx_cells,            # Create ggplot2 plot scaled to 1.00
             aes(x = Mixture,
                 y = Frequency,
                 fill = Cells, width = 1)) + # Width bar
  geom_bar(position = "fill", stat = "identity") + 
  scale_fill_manual(values = mycolors) + # RColorBrewer palettes
  theme_minimal() + # Add a theme
  scale_y_continuous(labels = scales::percent_format()) + # Scaled to 100%
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) # # Rotate the Legend

p1                              
dev.copy2pdf(file="Stacked_barplot.pdf", width = 8, height =7)
dev.off()


# Calculate percentage of each Cell_stage for each patient

CIBERSORTx_percent <- CIBERSORTx_results  |> 
  pivot_longer(-Mixture, names_to = "Cell_stage", values_to = "value") |> 
  group_by(Mixture, Cell_stage) |> 
  summarize(sum_value = sum(value)) |> 
  group_by(Mixture) |> 
  mutate(percent = sum_value / sum(sum_value) * 100) |> 
  ungroup() |> 
  select(-sum_value) |> 
  pivot_wider(names_from = Cell_stage, values_from = percent)


# Write the final table
write.table(CIBERSORTx_percent, file="CIBERSORTx_percent.csv", sep="\t", 
            row.names = FALSE)



