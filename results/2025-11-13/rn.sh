lilibrary(data.table)
library(ggplot2)
library(cowplot)
library(tools)
tsv_files <- list.files( "../../bigdata/bwa_scores", pattern = "Brachy_(Blank|cells).*\\.tsv$", full.names = TRUE, recursive = TRUE)
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
    dt_best <- dt[, .( best_score = do.call(pmax, .SD), best_ref   = score_cols[max.col(.SD, ties.method = "first")]), .SDcols = score_cols]
    dt_best[, read_len:=nchar(dt[,seq])]
    dt_best[, prop := best_score / read_len]
    dt_best[, ref := sub(".*@", "", best_ref)]

    library(ggplot2)
    library(dplyr)
    library(tidyr)  # needed for unnest

    dt_norm <- dt_best %>% group_by(best_ref) %>%
      summarise( dens = list(density(best_score / read_len, adjust = 1.2)), .groups = "drop") %>%
      mutate( x = lapply(dens, function(d) d$x), y = lapply(dens, function(d) d$y / max(d$y))) %>%
      select(best_ref, x, y) %>% unnest(cols = c(x, y))  # tidyr unnest

    # Plot
    p <- ggplot(dt_norm, aes(x = x, y = y, color = best_ref)) +
      geom_line(size = 1) + labs( x = "Best Score / Read Length", y = "Density (normalized by max)",
        title = "Alignment Quality per Reference (Peak Normalized)"
      ) +
      theme_minimal(base_size = 6) +
      theme(
        plot.title = element_text(hjust = 0.5),
        legend.title = element_blank()
      )
    if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)
    ggsave(paste0("figures/alignment_proportion_",sample_name,".png"), plot = p, width = 6, height = 4, dpi = 300)

  }
}






