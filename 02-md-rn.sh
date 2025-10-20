
input=( bigdata/bwa/results/*.dedup.rg.bam )
fn(){
    n=${1##*/};n=${n%.dedup.rg.bam}
    r=${1##*\@};r=bigdata/bwa/idx/${r%.dedup.*}.fa; ## genome 
    o=bigdata/mapdamage/$n; mkdir -p $o;
    echo "#!/bin/bash
    mapDamage --single-strand  -i $1 -r $r -d $o --merge-reference-sequences" | sbatch --mem=24g -o $o/slurm.out -J $n.$r.md

};export -f fn

parallel fn {} ::: ${input[@]:1}

