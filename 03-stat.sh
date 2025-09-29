samples=(
        Brachy_Blank
        Brachy_cells
        Brachy_c_sedi
        Brachy_vessels
        Brachy_v_sedi
        Trex_cells
        Trex_c_sedi
        Trex_ExtrBlank
        Trex_vessels
        Trex_v_sedi
)
species=(
	allMis1
#        anoCar2
        galGal6
        hg38
)

filt_kr(){
	samtools view -hF0x4 $1 |\
	perl -e 'use strict;
	my %h=map{chomp;$_=>1} `cat '$2' | grep "^C"|cut -f2`;
	while(<>){chomp; my@d=split/\t/,$_;
		if($d[0]=~/^@/){
			print $_,"\n";next;
		}
		if(!defined $h{$d[0]}){
			print $_,"\n";
		}	
	}
	' | samtools view -bh 
};export -f filt_kr

for s in ${samples[@]};do
	kr=bigdata/kr2/results/$s.k2_output.txt
	for p in ${species[@]};do
		b=bigdata/bwa/results/$s@$p.dedup.rg.bam
		o=bigdata/stat/$s@$p.bed
		mkdir -p ${o%/*}
		samtools view -q20 -F0x04 $b | dino sam2score - $p | head -n 1000000
		#echo "#!/bin/bash
		#source /mnt/vstor/SOM_GENE_BEG33/mamba/miniforge3/etc/profile.d/conda.sh
		#mamba activate dino_env
		#bamToBed -i $b | intersectBed -a stdin -b \
		#	<( dino ucsc-simplerep2bed <( gunzip -dc bigdata/ucsc/anno/$p/simpleRepeat.txt.gz) ) -v |\
		#	intersectBed -a stdin -b <( dino ucsc-nestedrep2bed <( gunzip -dc bigdata/ucsc/anno/$p/nestedRepeats.txt.gz))  -v > $o
		#" | sbatch 
		#echo "#!/bin/bash
		#filt_kr $b $kr > ${b%.bam}.un_kr.bam
		#" | sbatch --mem=64g -c 4
		#gunzip -dc $f | dino simplerep2bed - | head
	done  | dino score-max - | sort -k 1 
	exit
done

exit
input_ref=( galGal6)
d_ucsc/csc/anno/galGal6/exon.bed
ucsc_anno=/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/ucsc/anno #/galGal6/gene.bed #nestedrep.bed #simplerep.bedh


input=(
bigdata/leehom/Brachy_Blank.fq.gz
bigdata/leehom/Brachy_cells.fq.gz
bigdata/leehom/Brachy_c_sedi.fq.gz
bigdata/leehom/Brachy_vessels.fq.gz
bigdata/leehom/Brachy_v_sedi.fq.gz
bigdata/leehom/Trex_cells.fq.gz
bigdata/leehom/Trex_c_sedi.fq.gz
bigdata/leehom/Trex_ExtrBlank.fq.gz
bigdata/leehom/Trex_vessels.fq.gz
bigdata/leehom/Trex_v_sedi.fq.gz
)

fn(){
	echo "#!/bin//bash
	gunzip -dc $1 |  fo fq-len - > $1.len
	" | sbatch --mem=24g -c 4
};export -f fn;

#parallel fn {} ::: ${input[@]}

/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/ucsc/anno/galGal6/gene.bed
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/ucsc/anno/galGal6/nestedrep.bed
/mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/ucsc/anno/galGal6/simplerep.bed

