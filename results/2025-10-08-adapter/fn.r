library(data.table)
library(ggplot2)

# Define directories

md_save_pdf <- function(p, f, width = 10, height = 20) {
  # Print plot inline
  print(p)
  
  # Save PDF
  ggsave(filename = f, plot = p, width = width, height = height)
  
  # Return clickable Markdown link
  cat(sprintf("[PDF](%s)\n", f))
}
    
plt_adapter=function(files){
    #output="adapter.pdf";
    #files <- list.files("../adapter", pattern = "\\.adapter$", full.names = TRUE)
    read_adapter_file <- function(filepath) {
      dt <- fread(filepath)
      dt_long <- melt( dt, id.vars = "pos", variable.name = "adapter", value.name = "count")
      dt_long[, sample := sub("^([A-Za-z0-9]+_[A-Za-z0-9]+).*", "\\1", basename(filepath))]
      dt_long[, pair := sub(".*_R([12])_.*", "R\\1", basename(filepath))]
      return(dt_long)
    }
    adapter_data <- rbindlist(lapply(files, read_adapter_file))
    adapter_data[, base_adapter := sub("^rc_", "", adapter)]
    unique_bases <- unique(adapter_data$base_adapter)
    adapter_colors <- setNames( scales::hue_pal()(length(unique_bases)), unique_bases)

    # Annotate line type (solid vs dotted)
    adapter_data[, line_type := ifelse(grepl("^rc_", adapter), "revcompl", "orig")]
    adapter_data[, color := adapter_colors[base_adapter]]

    # Plot each sample separately
    library(ggplot2)
    library(data.table)

    dt <- adapter_data[!is.na(count)]

    ggplot(dt, aes(x = pos, y = count, color = base_adapter, linetype = line_type)) +
      geom_line(size = 0.8) +
      scale_color_manual(values = adapter_colors) +
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
