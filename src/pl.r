library(data.table)
library(ggplot2)

input="results/2025-10-08-read-adapter-positions/summary.tsv"
dt <- fread(input)
cols <- c("R1_trimmed", "R2_trimmed", "merged")
dt_long <- dt[, .(sample = sample, variable = rep(cols, each = .N), value = c(R1_trimmed, R2_trimmed, merged))]
ggplot(dt_long, aes(x = sample, y = value / 1e6, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Read Processing Summary",
    y = "Reads (millions)", x = "Sample", fill = "Category"
  ) + theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
