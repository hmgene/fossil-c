
#Xs = i7 index sequence
#5′-CAAGCAGAAGACGGCATACGAGATNNNNNNNNNXXXXXXXXGTGACTGGAGTTCAGACGTGT-3′
#
#Forward Index Primer Sequence (i5)
#5′-AATGATACGGCGACCACCGAGATCTACACXXXXXXXXACACTCTTTCCCTACACGACGCTCTTCCGATCT-3′
#
#Reverse Index Primer Sequence (Ui7)
#5′-CAAGCAGAAGACGGCATACGA-3′



echo \
">f
AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
>b
AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
>i7_5
CAAGCAGAAGACGGCATACGAGAT
>i7_3
GTGACTGGAGTTCAGACGTGT
>i5_5
AATGATACGGCGACCACCGAGATCTACAC
>i5_3
ACACTCTTTCCCTACACGACGCTCTTCCGATCT
>ui7
CAAGCAGAAGACGGCATACGA"   > adapters.fa

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
#bigdata/leehom/Brachy_Blank_r1.fail.fq.gz
)

odir=bigdata/adapter;mkdir -p $odir
for r1 in ${input[@]};do
	r2=${r1/_R1/_R2};
	o1=$odir/${r1##*/};
	o2=${o1/_R1/_R2};
	echo "#!/bin/bash
	gunzip -dc $r1 | dino fq-adapter - adapters.fa > $o1.adapter
	gunzip -dc $r2 | dino fq-adapter - adapters.fa > $o2.adapter
	" | sbatch 
done
