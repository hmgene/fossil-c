
input=(
bracky_blank_scaffolds,../../bigdata/spades/Brachy_Blank/scaffolds.fasta  
bracky_blank_contigs,../../bigdata/spades/Brachy_Blank/contigs.fasta  
bracky_cell_scaffolds,../../bigdata/spades/Brachy_cells/scaffolds.fasta 
)
output=../../bigdata/spades/scaffold.info.txt.gz

fn(){
    n=`echo $1 | cut -d "," -f 1`
    i=`echo $1 | cut -d "," -f 2`
    dino fa2flat $i |  perl -ne 'chomp;$_=~/_cov_([\d\.]+)\t(\w+)/; print "'$n'\t$1\t",length($2),"\n";' 
};export -f fn

parallel fn {} ::: ${input[@]} | gzip -c > $output 
Rscript -e '
library(data.table)
library(ggplot2)

tt=fread("'$output'")
tt=fread("../../bigdata/spades/scaffold.info.txt.gz")
names(tt)=c("sample","cov","contig_len");


library(ggplot2)
library(data.table)
library(viridis)  # install if missing

tt <- as.data.table(tt)

p <- ggplot(tt, aes(x = contig_len, y = cov)) +
    geom_bin2d(bins = 50) +
    scale_fill_viridis(option = "magma", trans = "log10") +  # log10 scale for counts
    scale_x_log10() +
    scale_y_log10() +
    facet_wrap(~ sample, scales = "fixed") +
    theme_bw() +
    labs(
        x = "log10 Contig length (bp)",
        y = "log10 Coverage",
        fill = "log10(Count)",
        title = "Coverage vs Contig/Scaffold Length"
    )

ggsave("figures/scaffold_dist.png", plot = p, width = 8, height = 6, dpi = 300)
'
