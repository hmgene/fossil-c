
library(data.table)
library(stringr)

# -----------------------------
# 1. Summary table
# -----------------------------

summary <- fread(text = "
Sample Total_Reads Reads_Merged Merged_Reads Aligned
FHU_D16_B03p_no-hit 1 1 1 1
FHU_D16_B04p_no-hit 1 1 1 1
FHU_D16_B05p_no-hit 1 1 1 1
")

# -----------------------------
# 2. Process each sample
# -----------------------------
for (i in 1:nrow(summary)) {
  sample_name <- summary[i,Sample]
  cat("\n###", sample_name, "\n")
  file_path <- paste0("data/alignment_proportion_", sample_name, ".csv.gz")

  if (!file.exists(file_path)) {
    cat("Skipping:", file_path, "(file not found)\n")
    next
  }
total <- summary[i,Total_Reads]
merged = summary[i,Merged_Reads]
notmerged= total/2 - merged
aligned <- summary[i,Aligned]

#cat("Total [", merged, "] Merged\n", sep="")
#cat("Total [", notmerged, "] NotMerged\n", sep="")
#cat(sample_name," [", aligned, "] Aligned\n", sep="")

  dt <- fread(file_path)
  for( ref_label in unique(dt$ref_label)){
      species <- str_extract(ref_label, "^[^\\(]+")
      n <- str_extract(ref_label, "(?<=\\(n=)\\d+(?=\\))")
      cat(sample_name," [", n, "] ", trimws(species), "\n", sep="")
  }
}

