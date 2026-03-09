

input=( 
     bwa_results/*.rg.bam
)
output="bwa_scores"
mkdir -p $output
for i in ${input[@]}; do 
    echo $i | perl -pe 's#.*/([^@]+)@([^.]+).*#$1#' 
done  | sort -u | while read s;do 
    o=$output/$s.tsv
    echo "#!/bin/bash
    parallel --line-buffer samtools view -q 20 {} ::: bwa_results/$s@*.dedup.rg.bam |\
    dino sam2score - > $o
    " | sbatch --mem=94g -o $o.out 
done

