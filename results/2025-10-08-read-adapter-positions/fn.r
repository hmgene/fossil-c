library(data.table)
library(ggplot2)

# Define directories

md_save_pdf <- function(p, f, width = 10, height = 20) {
  print(p)
  ggsave(filename = f, plot = p, width = width, height = height)
  cat(sprintf("[PDF](%s)\n", f))
}
    
plt_adapter=function(files){
    library(ggplot2)
    library(data.table)

    #output="adapter.pdf";
    #files <- list.files("../adapter", pattern = "\\.adapter$", full.names = TRUE)
    read_adapter_file <- function(filepath) {
        lines <- readLines(filepath, n = 2)
        N <- as.integer(sub("#N=", "", lines[grepl("#N=", lines)]))
        M <- as.integer(sub("#M=", "", lines[grepl("#M=", lines)]))

      dt <- fread(filepath)
      dt_long <- melt( dt, id.vars = "pos", variable.name = "adapter", value.name = "count")
      dt_long[, sample := sub("^([A-Za-z0-9]+_[A-Za-z0-9]+).*", "\\1", basename(filepath))]
      dt_long[, pair := sub(".*_R([12])_.*", "R\\1", basename(filepath))]
      dt_long[, `:=`(N = N, M = M)]
      return(dt_long)
    }

    adapter_data <- rbindlist(lapply(files, read_adapter_file))
    adapter_data[, base_adapter := sub("^rc_", "", adapter)]
    unique_bases <- unique(adapter_data$base_adapter)
    adapter_colors <- setNames( scales::hue_pal()(length(unique_bases)), unique_bases)
    adapter_data[, line_type := ifelse(grepl("^rc_", adapter), "revcompl", "orig")]
    adapter_data[, color := adapter_colors[base_adapter]]

annotations <- adapter_data[, .(
  xpos = max(pos),  # center of panel
  ypos = Inf,               # top of panel
  label = paste0("AdapterRate=", M, "/", N, " (", round(M/N*100, 3), "%)")
), by = .(sample, pair)]

    dt <- adapter_data[!is.na(count)]
    ggplot(dt, aes(x = pos, y = count, color = base_adapter, linetype = line_type)) +
      geom_line(size = 0.8) +
      scale_color_manual(values = adapter_colors) +
  geom_text(
    data = annotations,
    aes(x = xpos, y = ypos, label = label),
    inherit.aes = FALSE,
    hjust = 1, vjust = 1,
    size = 3
  ) +
      scale_linetype_manual(values = c(orig = "solid", revcompl = "dotted"),
                            labels = c(orig = "Adapter", revcompl = "Reverse Complement")) +
      labs(x = "Position", y = "Count", color = "Adapter", linetype = "Strand") +
      facet_grid(sample ~ pair, scales = "free_y") +  # ← rows = sample, columns = R1/R2
      theme_bw(base_size = 12) +
      theme(
        strip.text = element_text(size = 12, face = "bold"),
        legend.position = "right"
      )
}

pl_summary=function(input=NULL){
if(is.null(input)){
    input="results/2025-10-08-read-adapter-positions/summary.tsv"
}
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
}

