
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

