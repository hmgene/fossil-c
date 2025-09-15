# ref : https://archaeogenetics.readthedocs.io/en/latest/4_ReadsMapping_v2.html
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
odir=bigdata/bwa/results; mkdir -p $odir
idx=(
	bigdata/bwa/idx/allMis1.fa
	bigdata/bwa/idx/anoCar2.fa
	bigdata/bwa/idx/galGal6.fa
	bigdata/bwa/idx/hg38.fa
)

for i in ${input[@]};do 
for j in ${idx[@]};do
	s=${i##*/};s=${s%.fq.gz*};
	r=${j##*/};r=${r%.fa*};
	o=$odir/$s@$r;
	echo "#!/bin/bash -l
	mamba activate dyno_env
	bwa aln $j $i -n 0.01 -l 1000 -o 2 > $o.sai
	bwa samse $j $o.sai $i -f $o.sam
	samtools view -F0x4 -hb $o.sam | samtools sort - -@ 16 -T $o > $o.bam
	samtools index $o.bam
	rm $o.sam
	" | sbatch --mem=64g -c 24 
done
done
