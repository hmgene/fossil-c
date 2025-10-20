#!/bin/bash
input=(
	bigdata/ucsc/fa/allMis1.fa
	bigdata/ucsc/fa/anoCar2.fa
	bigdata/ucsc/fa/galGal6.fa
	bigdata/ucsc/fa/hg38.fa
    bigdata/ucsc/fa/mm10.fa.gz
    bigdata/ucsc/fa/loxAfr3.fa.gz
    bigdata/genome/bearded_dragon.fna.gz
    bigdata/genome/brown_anole.fna.gz
    bigdata/genome/crocodile.fna.gz
    bigdata/genome/falcon.fna.gz
    bigdata/genome/komodo_dragon.fna.gz
    bigdata/genome/ostrich.fna.gz
)

fn(){
    i=$1;
    o=bigdata/bwa/idx/${i##*/};o=${o%.fa*};o=${o%.fna*}.fa
    [ -s $o ] || dino mycat $i > $o
	[ -s $o.sa ] || echo "#!/bin/bash
		bwa index $o" | sbatch --mem=24g -c 8 -o $o.sa.out
	[ -s $o.fai ] || echo "#!/bin/bash
		samtools faidx $o " | sbatch  -o $o.fai.out
	[ -s ${o%.fa}.dict ] || echo "#!/bin/bash
		java -jar bigdata/picard.jar CreateSequenceDictionary  R=$o O=${o%.fa}.dict " | sbatch -o ${o%.fa}.dict.out

};export -f fn;

mkdir -p bigdata/bwa/idx
parallel fn {} ::: ${input[@]}
