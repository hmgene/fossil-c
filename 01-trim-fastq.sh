input=(
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_Blank_S9_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_cells_S5_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_c_sedi_S7_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_vessels_S6_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_v_sedi_S8_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_cells_S10_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_c_sedi_S12_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_ExtrBlank_S14_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_vessels_S11_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_v_sedi_S13_L002_R1_001.fastq.gz

)

for f in ${input[@]};do
	n=${f##*/};n=${n%_S*};
	o=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/leehom/$n
	mkdir -p ${o%/*}
	echo "#!/bin/bash 
	#dino leeHom --ancientdna -t 16 \
	#	-f AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
	#	-s AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
	#-fq1 $f -fq2 ${f/_R1/_R2}  -fqo $o
        #gunzip -dc $o.fq.gz |  fo fq-len - > $o.len
        gunzip -dc $o.fq.gz |  wc -l > $o.n
	gunzip -dc ${o}_r1.fail.fq.gz | wc -l >> $o.n
	awk '{ s+=\$1;}END{ print s/4;}' $o.n  > $o.n.tmp
	mv $o.n.tmp $o.n
	" #| sbatch --mem=64g -c 24
done
