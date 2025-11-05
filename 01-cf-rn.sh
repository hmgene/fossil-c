input=(
bigdata/leehom/Brachy_Blank.fq.gz  
bigdata/leehom/Brachy_cells.fq.gz
)
x=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/centrifuge/nt

for f in ${input[@]};do
	n=${f##*/};n=${n%.fq.gz};
	o=bigdata/centrifuge/results/$n
	mkdir -p ${o%/*}
	echo "#!/bin/bash
		mamba activate dino_env
	   	centrifuge -p 16 -x $x -U $f --report-file $o.tsv --min-hitlen 16 --score-min L,0,-0.2 -k 5 > $o.txt
        centrifuge-kreport -x $x $o.txt > $o.krreport.txt 
        " #| sbatch --mem=512g -c 24 -p smp -o $o.out -e $o.err
done 
