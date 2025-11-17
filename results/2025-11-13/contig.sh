
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
names(tt)=c("sample","cov","contig_len");


p=ggplot(tt, aes(x = contig_len, y = cov)) +
    geom_point(alpha = 0.6) +
    scale_x_log10() +           # recommended for contig lengths
    scale_y_log10() +           # optional for coverage
    facet_wrap(~ sample, scales = "free") +
    theme_bw() +
    labs(
        x = "Contig length (bp)",
        y = "Coverage",
        title = "Coverage vs Contig Length per Sample"
    )

ggsave("figures/scaffold_dist.png", plot = p, width = 8, height = 6, dpi = 300)
'
