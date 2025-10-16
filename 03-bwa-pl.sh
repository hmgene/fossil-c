
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
  
  # TSV 읽기
  dt <- fread(tsv)
  
  # id, seq 제외하고 score 컬럼만 선택
  score_cols <- setdiff(names(dt), c("id", "seq"))
  
  # row별 최고 점수와 해당 reference
  dt_best <- dt[, .(
    best_score = do.call(pmax, .SD),
    best_ref   = score_cols[max.col(.SD, ties.method = "first")]
  ), .SDcols = score_cols]
  
  # score > 20 필터
  dt_best_filtered <- dt_best[best_score > 20]
  
  # 총 row 수와 score>20 row 수
  total_N <- nrow(dt_best)
  short_N <- nrow(dt_best_filtered)

  p <- ggplot(dt_best_filtered, aes(x = best_score, fill = best_ref)) +
    geom_histogram(binwidth = 10, position = "stack", color = "black") +
    ggtitle(paste0(sample_name, " | Total IDs: ", total_N, " | Score>20 IDs: ", short_N)) +
    xlab("Best Score") + ylab("Count") +
    theme_bw() +
    theme(legend.position = "right")
  
  # PNG 저장
  ggsave(filename = paste0("bigdata/bwa_scores/", sample_name, "_best_score_stacked.png"),
         plot = p, width = 10, height = 6)

  p <- ggplot(dt_best_filtered, aes(x = best_score, fill = best_ref)) +
    geom_histogram(position = "identity", alpha = 0.5, bins = 50) +
    ggtitle(paste0(sample_name, " | Total IDs: ", total_N, " | Score>20 IDs: ", short_N)) +
    xlab("Best Score") + ylab("Count") + theme_bw() + theme(legend.position = "right")
  
  # PNG 저장
  ggsave(filename = paste0("bigdata/bwa_scores/", sample_name, "_best_score_hist.png"),
         plot = p, width = 10, height = 6)
}

'
}
pl-bwa-score

