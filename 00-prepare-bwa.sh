#!/bin/bash
input=(
	bigdata/bwa/idx/allMis1.fa
	bigdata/bwa/idx/anoCar2.fa
	bigdata/bwa/idx/galGal6.fa
	bigdata/bwa/idx/hg38.fa
)

fn(){
	[  -s $1.sa ] || echo "#!/bin/bash
		bwa index $1
	" | sbatch --mem=24g -c 8
	[ -s $1.fai ] || echo "#!/bin/bash
		samtools faidx $1
	" | sbatch 
	[ -s ${1%.fa}.dict ] || echo "#!/bin/bash
		java -jar bigdata/picard.jar CreateSequenceDictionary  R=$1 O=${1%.fa}.dict 
	" | sbatch 

};export -f fn;
parallel fn {} ::: ${input[@]}
