input=(
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/leehom/Trex_cells.fq.gz
)
x=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/centrifuge/hpvc

for f in ${input[@]};do
	n=${f##*/};n=${n%.fq.gz};
	o=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/centrifuge/$n
	mkdir -p ${o%/*}
	echo "#!/bin/bash
		mamba activate dino_env
	   	centrifuge -p 16 -x $x -U $f --report-file $o.tsv  > $o.txt
		#awk '\$3==\"U\" {print \$1}' $o.txt > unclassified_reads_ids.txt
		#seqtk subseq Trex_cells_S10_L002_R1_001.fastq.gz unclassified_reads_ids.txt > R1.filtered.fastq

        " #| sbatch --mem=96g -c 24
done 
