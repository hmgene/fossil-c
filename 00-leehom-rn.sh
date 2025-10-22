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
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/Human/ERR13475326_1.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/Mammuthus/ERR5024913_1.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/Mammuthus/ERR5032053_1.fastq.gz
)

for f in ${input[@]};do
	n=${f##*/};n=${n%_S*};n=${n%_?.fastq.gz};
	o=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/leehom/$n
	if [ -s $o.fq.gz ];then 
		echo "$o.fq.gz exists! skip leehom"
	else
		mkdir -p ${o%/*}
		if [ ${f%ERR*} == $f ];then
			echo "#!/bin/bash 
			set -euo pipefail
			dino leeHom --ancientdna -t 16 \
				-f AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
				-s AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
				--umif 9 \
				-fq1 $f -fq2 ${f/_R1/_R2}  -fqo $o
			gunzip -dc $o.fq.gz | dino fq-len - > $o.len
			gunzip -dc $o.fq.gz | sed -n '2~4p' | wc -l > $o.fq.gz.n 
			gunzip -dc ${o}_r1.fq.gz | sed -n '2~4p' | wc -l > ${o}_r1.fq.gz.n 
			gunzip -dc ${o}_r2.fq.gz | sed -n '2~4p' | wc -l > ${o}_r2.fq.gz.n 
			gunzip -dc ${o}_r1.fail.fq.gz | sed -n '2~4p' | wc -l > ${o}_r1.fail.fq.gz.n 
			gunzip -dc ${o}_r2.fail.fq.gz | sed -n '2~4p' | wc -l > ${o}_r2.fail.fq.gz.n 

			" #| sbatch --mem=64g -c 24 -J "lee_$n" -o $o.slurm.out
		else
			echo "#!/bin/bash 
			set -euo pipefail
			dino leeHom --ancientdna -t 16 \
				-fq1 $f -fq2 ${f/_1.fastq/_2.fastq}  -fqo $o
			gunzip -dc $o.fq.gz | dino fq-len - > $o.len
			gunzip -dc $o.fq.gz | sed -n '2~4p' | wc -l > $o.fq.gz.n 
			gunzip -dc ${o}_r1.fq.gz | sed -n '2~4p' | wc -l > ${o}_r1.fq.gz.n 
			gunzip -dc ${o}_r2.fq.gz | sed -n '2~4p' | wc -l > ${o}_r2.fq.gz.n 
			gunzip -dc ${o}_r1.fail.fq.gz | sed -n '2~4p' | wc -l > ${o}_r1.fail.fq.gz.n 
			gunzip -dc ${o}_r2.fail.fq.gz | sed -n '2~4p' | wc -l > ${o}_r2.fail.fq.gz.n 
			" #| sbatch --mem=64g -c 24 -J "leehom_$n" -o $o.slurm.out
			
		fi

	fi
done
