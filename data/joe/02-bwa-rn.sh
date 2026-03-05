# ref : https://archaeogenetics.readthedocs.io/en/latest/4_ReadsMapping_v2.html
input=(
    *.fastq
)
odir=`realpath bwa_results`; mkdir -p $odir
idx=( 
    ../../bigdata/bwa/idx/Brachy_Blank_scaffolds_len10k.fa
    ../../bigdata/bwa/idx/Brachy_cells_scaffolds_len10k.fa
    ../../bigdata/bwa/idx/Brachy_vessels_scaffolds_len10k.fa
    ../../bigdata/bwa/idx/Trex_cells_scaffolds_len10k.fa
    ../../bigdata/bwa/idx/Trex_vessels_scaffolds_len10k.fa
)

gatk=../../bigdata/gatk/gatk-4.6.2.0/gatk

for i in ${input[@]};do 
for j in ${idx[@]};do
	i=`realpath $i`
	j=`realpath $j`
	s=${i##*/};s=${s%.fq.gz*}; s=${s%.fastq};
	r=${j##*/};r=${r%.fa*};
	o=$odir/$s@$r;
    if [ -s $o.dedup.rg.bam ];then
        echo "$o exists!"; continue;
    fi
	#[ -s $o ] || echo "#!/bin/bash -l
	echo "#!/bin/bash -l
	mamba activate dino_env

	bwa aln $j $i -t 24 -n 0.01 -l 1000 -o 2 > $o.sai
	bwa samse $j $o.sai $i -f $o.sam
	samtools view -q 20 -F0x4 -hb $o.sam | samtools sort - -@ 16 -T $o > $o.bam
	dino gatk-run $o $o.bam $j 16
	#rm $o.sam
	" | sbatch --mem=64g -c 24 --time=100:00:00 -o $o.dedup.rg.bam.out
done
done
