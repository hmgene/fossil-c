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
};export -f fn;
parallel fn {} ::: ${input[@]}
