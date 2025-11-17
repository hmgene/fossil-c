
input=(
../../bigdata/spades/Brachy_Blank/scaffolds.fasta  
../../bigdata/spades/Brachy_cells/scaffolds.fasta 
)
output=../../bigdata/spades/scaffold.info.txt.gz

fn(){
    n=${1#*/spades/};n=${n%/scaffolds*}
    dino fa2flat $1 | perl -ne 'chomp;$_=~/_cov_([\d\.]+)\t(\w+)/; print "'$n'\t$1\t",length($2),"\n";' 
};export -f fn

parallel fn {} \ ::: ${input[@]} > $output 

Rscript -e '
library(data.table)
library(ggplot2)

tt=fread("scaffold.info.txt.gz")
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
