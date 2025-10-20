
library(data.table)
library(ggplot2)
library(cowplot)
library(tools)
tsv_files <- list.files( "../../bigdata/bwa_scores", pattern = "(Brachy|Trex).*\\.tsv$", full.names = TRUE, recursive = TRUE)

pattern_order <- c("cells", "vessels", "c_sedi", "v_sedi", "blank")
tsv_files<- tsv_files[order(sapply(tsv_files, function(x) {
  x_lower <- tolower(basename(x))
  idx <- which(sapply(pattern_order, function(p) grepl(p, x_lower, fixed = TRUE)))
  if(length(idx) == 0) return(Inf) else return(idx[1])
}))]


get_group_name <- function(f) { strsplit(basename(f), "_")[[1]][1]; }
groups <- split(tsv_files, sapply(tsv_files, get_group_name))
all_group_plots <- list()
for (grp in names(groups)) {
  message("Processing group: ", grp); plots <- list()


  for (tsv in groups[[grp]]) {

    sample_name <- file_path_sans_ext(basename(tsv))
    dt <- fread(tsv)
    score_cols <- setdiff(names(dt), c("id", "seq"))
    if (length(score_cols) == 0) next

    dt_best <- dt[, .(
      best_score = do.call(pmax, .SD),
      best_ref   = score_cols[max.col(.SD, ties.method = "first")]
    ), .SDcols = score_cols]

    dt_best_filtered <- dt_best[best_score > 20]
    total_N <- nrow(dt_best)
    long_N <- nrow(dt_best_filtered)
    if (long_N == 0) next

    p <- ggplot(dt_best_filtered, aes(x = best_score, fill = best_ref)) +
      geom_histogram(binwidth = 10, position = "stack", color = "black") +
      ggtitle(paste0(sample_name, " | Total: ", total_N, " | >20: ", long_N)) +
      xlab("Best Score") + ylab("Count") +
      theme_bw(base_size = 9) +
      theme(legend.position = "none")

    plots[[sample_name]] <- p
  }
  if (length(plots) == 0) next
  rightmost_plot <- plots[[length(plots)]]
  legend <- get_legend( rightmost_plot + theme(legend.position = "right", legend.title = element_text(size = 9)))

  combined_row <- plot_grid(plotlist = lapply(plots, function(p) p + theme(legend.position = "none")), ncol = length(plots), align = "hv")
  final_plot <- plot_grid(combined_row, legend, ncol = 2, rel_widths = c(1, 0.15)); 
  all_group_plots[[grp]] <- final_plot
}

# Combine all group plots vertically
all_groups_grid <- plot_grid(plotlist = all_group_plots, ncol = 1, align = "v", labels = names(all_group_plots))

# Save safely
dir.create("figs")
ggsave("figs/bwa_score_grid.png", all_groups_grid, width = 30, height = 5 * length(all_group_plots), limitsize = FALSE, dpi = 300)

