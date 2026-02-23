


input=( 
    `ls bigdata/bwa/results/{Bra,Tre}*.dedup.rg.bam`
)
output="bigdata/bwa_scores_+contig"
mkdir -p $output

for i in ${input[@]}; do 
    echo $i | perl -pe 's#.*/([^@]+)@([^.]+).*#$1#' 
done  | sort -u | while read s;do 
    o=$output/$s.tsv
    echo "#!/bin/bash
    parallel --line-buffer samtools view -q 20 {} ::: bigdata/bwa/results/$s@*.dedup.rg.bam |\
    dino sam2score - > $o
    " | sbatch --mem=94g -o $o.out 
done

exit

pl-bwa-score(){

Rscript -e '
library(data.table)
library(ggplot2)

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

