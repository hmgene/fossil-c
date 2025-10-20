
input="bigdata/bwa/results/*.dedup.rg.bam"
output=bigdata/bwa_scores;mkdir -p $output
ls $input | perl -pe 's#.*/([^@]+)@([^.]+).*#$1#' | sort -u | while read -r s; do
    o=$output/$s.tsv
    [ -s $o ] || echo "#!/bin/bash
    parallel --line-buffer samtools view -q 20 {} ::: bigdata/bwa/results/$s@*.dedup.rg.bam |\
    dino sam2score - > $o
    "  | sbatch --mem=24g -o $o.out 
done

pl-bwa-score(){

Rscript -e '
library(data.table)
library(ggplot2)

# TSV 파일 경로
tsv_files <- list.files("bigdata/bwa_scores/", pattern = "*.tsv$", full.names = TRUE)

for (tsv in tsv_files) {
  sample_name <- tools::file_path_sans_ext(basename(tsv))
  dt <- fread(tsv)
  score_cols <- setdiff(names(dt), c("id", "seq"))
  dt_best <- dt[, .(
    best_score = do.call(pmax, .SD),
    best_ref   = score_cols[max.col(.SD, ties.method = "first")]
  ), .SDcols = score_cols]
  dt_best_filtered <- dt_best[best_score > 20]
  total_N <- nrow(dt_best)
  short_N <- nrow(dt_best_filtered)

  p <- ggplot(dt_best_filtered, aes(x = best_score, fill = best_ref)) +
    geom_histogram(binwidth = 10, position = "stack", color = "black") +
    ggtitle(paste0(sample_name, " | Total IDs: ", total_N, " | Score>20 IDs: ", short_N)) +
    xlab("Best Score") + ylab("Count") +
    theme_bw() +
    theme(legend.position = "right")
  ggsave(filename = paste0("bigdata/bwa_scores/", sample_name, "_best_score_stacked.png"),
         plot = p, width = 10, height = 6)


'
}
pl-bwa-score

