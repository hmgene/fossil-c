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
odir=`realpath bigdata/bwa/results`; mkdir -p $odir
idx=(
	bigdata/bwa/idx/allMis1.fa
	bigdata/bwa/idx/anoCar2.fa
	bigdata/bwa/idx/galGal6.fa
	bigdata/bwa/idx/hg38.fa
)

gatk=bigdata/gatk/gatk-4.6.2.0/gatk

for i in ${input[@]};do 
for j in ${idx[@]};do
	i=`realpath $i`
	j=`realpath $j`
	s=${i##*/};s=${s%.fq.gz*};
	r=${j##*/};r=${r%.fa*};
	o=$odir/$s@$r;
	echo "#!/bin/bash -l
	mamba activate dino_env

	bwa aln $j $i -t 24 -n 0.01 -l 1000 -o 2 > $o.sai
	bwa samse $j $o.sai $i -f $o.sam
	samtools view -F0x4 -hb $o.sam | samtools sort - -@ 16 -T $o > $o.bam
	fo gatk-run $o $o.bam $j 16
	#java -Xmx32g -jar bigdata/picard.jar MarkDuplicates \
	#    I=${o}.bam  O=${o}.DR.bam  M=${o}.metrics.txt  REMOVE_DUPLICATES=True 
	#samtools index -@ 8 ${o}.DR.bam
	#samtools view -H ${o}.DR.bam > ${o}.DR.bam.h 
	#echo -e \"@RG\tID:$s\tSM:$s\tPL:ILLUMINA\" >> ${o}.DR.bam.h
	#samtools reheader ${o}.DR.bam.h ${o}.DR.bam > ${o}.DR.h.bam 
	#samtools index ${o}.DR.h.bam
	#$gatk HaplotypeCaller -R $j -I ${o}.DR.h.bam -O $o.g.vcf.gz -ERC GVCF --sample-name $s


	#java -Xmx32g -jar $gatk -T RealignerTargetCreator  -R $j  -I ${o}.DR.bam  -o ${o}.DR.intervals -nt 8
	#java -Xmx32g -jar $gatk -T IndelRealigner  -R $j  -I ${o}.DR.bam  -targetIntervals ${o}.DR.intervals  -o ${o}.final.bam  --filter_bases_not_stored -nt 8
	#samtools index -@ 8 ${o}.final.bam

	#rm $o.sam
	" | sbatch --mem=64g -c 24  --time=100:00:00
done
done
