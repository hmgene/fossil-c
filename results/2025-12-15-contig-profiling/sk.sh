
library(data.table)
library(stringr)

# -----------------------------
# 1. Summary table
# -----------------------------

summary <- fread(text = "
Sample	Total_Reads	Reads_Merged	Merged_Reads	Aligned
Bracky_Blank	91592712	75539044	37769522	2559021
Bracky_cells	675698180	557543426	278771713	83688488
Bracky_vessels	327279862	315134305	157567152	29292117
Trex_cells	372679752	214655295	107327648	14415549
Trex_vessels	477581256	265159440	132579720	17602948
")

# -----------------------------
# 2. Process each sample
# -----------------------------
for (i in 1:nrow(summary)) {

  sample_name <- summary[i,Sample]
  cat("\n###", sample_name, "\n")
  file_path <- paste0("data/alignment_proportion_", sample_name, ".csv.gz")

  if (!file.exists(file_path)) {
    cat("Skipping:", sample_name, "(file not found)\n")
    next
  }
total <- summary[i,Total_Reads]
merged = summary[i,Merged_Reads]
notmerged= total/2 - merged
aligned <- summary[i,Aligned]

cat("Total [", merged, "] Merged\n", sep="")
cat("Total [", notmerged, "] NotMerged\n", sep="")
cat("Merged [", aligned, "] Aligned\n", sep="")

  dt <- fread(file_path)
  for( ref_label in unique(dt$ref_label)){
      species <- str_extract(ref_label, "^[^\\(]+")
      n <- str_extract(ref_label, "(?<=\\(n=)\\d+(?=\\))")
      cat("Aligned [", n, "] ", trimws(species), "\n", sep="")
  }
}

