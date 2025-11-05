

input=(
#/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_Blank_S9_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_cells_S5_L002_R1_001.fastq.gz
)
output=`realpath bigdata/w2rap`

for i in ${input[@]};do
    n=${i##*/};n=${n%_S*};
    r1=`realpath $i`;r2=${r1/_R1/_R2}
    o=$output/$n; mkdir -p $o
R1=${o}_R1.fq.gz
R2=${o}_R2.fq.gz
    echo "#!/bin/bash
export OMP_NUM_THREADS=16
export OMP_PROC_BIND=TRUE
zcat "$r1" | gzip > $R1
zcat "$r2" | gzip > $R2

    bigdata/tools/w2rap-contigger/bin/w2rap-contigger -o $o -p ${n}_test -r $R1,$R2 -K 100
    " | sbatch --mem=512g -p smp -c 24 -J w2r -o $o/out -e $o/err 
done
