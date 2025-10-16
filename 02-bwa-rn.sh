# ref : https://archaeogenetics.readthedocs.io/en/latest/4_ReadsMapping_v2.html
input=(
#	bigdata/leehom/Brachy_Blank.fq.gz
#	bigdata/leehom/Brachy_cells.fq.gz
#	bigdata/leehom/Brachy_c_sedi.fq.gz
#	bigdata/leehom/Brachy_vessels.fq.gz
#	bigdata/leehom/Brachy_v_sedi.fq.gz
#	bigdata/leehom/Trex_cells.fq.gz
#	bigdata/leehom/Trex_c_sedi.fq.gz
#	bigdata/leehom/Trex_ExtrBlank.fq.gz
#	bigdata/leehom/Trex_vessels.fq.gz
#	bigdata/leehom/Trex_v_sedi.fq.gz
bigdata/leehom/ERR5024913.fq.gz
bigdata/leehom/ERR5032053.fq.gz

)
odir=`realpath bigdata/bwa/results`; mkdir -p $odir
idx=( bigdata/bwa/idx/*.fa)
gatk=bigdata/gatk/gatk-4.6.2.0/gatk

for i in ${input[@]};do 
for j in ${idx[@]};do
	i=`realpath $i`
	j=`realpath $j`
	s=${i##*/};s=${s%.fq.gz*};
	r=${j##*/};r=${r%.fa*};
	o=$odir/$s@$r;
    if [ -s $o.dedup.rg.bam ];then
        echo "$o exists!"; continue;
    fi
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
