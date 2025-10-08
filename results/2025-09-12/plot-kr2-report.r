library(data.table)

files <- list.files("data", pattern="*.k2_report.txt", full.names=TRUE)
dt_list <- lapply(files, fread)
names(dt_list) <- basename(files)
for (nm in names(dt_list)) { dt_list[[nm]][, file := nm]; }
dt_all <- rbindlist(dt_list)

setnames(dt_all, c("perc","clade_reads","taxon_reads","clade_bp","taxon_bp","rank","taxid","name","file"))


# Files
files <- list.files("data", pattern="\\.k2_report\\.txt$", full.names = TRUE)

species_taxa <- c("Homo sapiens", "Gallus gallus", "Struthio camelus", "Crocodylus niloticus")
major_taxa <- c("Bacteria", "Virus", "Archaea", species_taxa, "unclassified")

summary_dt <- data.table()

for(f in files){
  dt <- fread(f, header=FALSE)
  setnames(dt, c("perc","clade_reads","taxon_reads","clade_bp","taxon_bp","rank","taxid","name"))
  
  # Convert perc to numeric
  dt[, perc := as.numeric(perc)]
  
  # Initialize major column
  dt[, major := "Others"]
  
  # Assign unclassified
  dt[name == "unclassified", major := "unclassified"]
  
  # Assign Bacteria/Virus/Archaea directly
  dt[name %in% c("Bacteria","Virus","Archaea"), major := name]
  
  # Assign species if ancestor nodes contain the species name
  for(sp in species_taxa){
    dt[grepl(sp, name, fixed=TRUE), major := sp]
  }
  
  # Sum clade reads per major taxon
  dt_sum <- dt[, .(clade_reads=sum(clade_reads)), by=major]
  
  # Normalize to 100%
  dt_sum[, perc := clade_reads / sum(clade_reads) * 100]
  
  dt_sum[, sample := basename(f)]
  
  summary_dt <- rbind(summary_dt, dt_sum, fill=TRUE)
}

# Reorder columns
setcolorder(summary_dt, c("sample","major","clade_reads","perc"))

# View summary
summary_dt

# Save
fwrite(summary_dt, "kraken2_major_taxa_hierarchy_with_unclassified.csv")

