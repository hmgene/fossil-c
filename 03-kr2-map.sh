input=(
bigdata/leehom/Brachy_Blank.fq.gz
bigdata/leehom/Brachy_cells.fq.gz
#bigdata/leehom/Brachy_c_sedi.fq.gz
#bigdata/leehom/Brachy_vessels.fq.gz
#bigdata/leehom/Brachy_v_sedi.fq.gz
#bigdata/leehom/Trex_cells.fq.gz
#bigdata/leehom/Trex_c_sedi.fq.gz
#bigdata/leehom/Trex_ExtrBlank.fq.gz
#bigdata/leehom/Trex_vessels.fq.gz
#bigdata/leehom/Trex_v_sedi.fq.gz
#bigdata/leehom/ERR5024913_1.fastq.gz.fq.gz #mammoth
#bigdata/leehom/ERR13475326_1.fastq.gz.fq.gz #human
)
dbs=( 
	#bigdata/kr2
    bigdata/kr2/nt_db
)
for db in ${dbs[@]};do 
for f in ${input[@]};do
        n=${f##*/};n=${n%.fq.gz};n=${n%.fastq.gz}
        o=$db/results/$n
        mkdir -p ${o%/*}
        echo "#!/bin/bash 
        dino kraken2 --db $db --report $o.k2_report.txt --report-minimizer-data  --confidence 0.00 --threads 16 --output $o.k2_output.txt $f 
        " | sbatch --mem=2000g -c 24 -p smp -o $o.slurm.out
done
done


