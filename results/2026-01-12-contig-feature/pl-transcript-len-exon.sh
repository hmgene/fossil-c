library(data.table)
library(ggplot2)

# Read data
cn <- c("gene_len","num_exons","count")
x <- fread("../../bigdata/augustus/Brachy_Blank.gff.stat")
names(x) <- cn
y <- fread("../../bigdata/augustus/Brachy_cells.gff.stat")
names(y) <- cn

p=ggplot(x, aes(x = gene_len, y = num_exons, z = count)) +
  geom_contour_filled() + scale_fill_viridis_d() +  # <-- use _d for discrete
  theme_minimal() + labs( title = "Contour Map of gene_len vs num_exons",
    x = "Gene length", y = "Number of exons", fill = "Count"
  )
ggsave(filename = "figures/contour_bracky_blank.png", plot = p, width = 8, height = 6, dpi = 150)


p=ggplot(y, aes(x = gene_len, y = num_exons, z = count)) +
  geom_contour_filled() + scale_fill_viridis_d() +  # <-- use _d for discrete
  theme_minimal() + labs( title = "Contour Map of gene_len vs num_exons",
    x = "Gene length", y = "Number of exons", fill = "Count"
  )
ggsave(filename = "figures/contour_bracky_cells.png", plot = p, width = 8, height = 6, dpi = 150)
