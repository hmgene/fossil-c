#!/bin/bash
input=(
#../../bigdata/spades/Brachy_cells/scaffolds.fasta 
#../../bigdata/spades/Brachy_vessels/scaffolds.fasta 
#../../bigdata/spades/Brachy_Blank/scaffolds.fasta
# ../../bigdata/spades/Trex_{cells,vessels}/contigs.fasta
# ../../bigdata/spades/Trex_cells/scaffolds.fasta
)

for i in ${input[@]};do
    n=`echo $i | cut -d"/" -f 5`;
    o=${i%/*}/${n}_scaffolds_len10k.fasta;
    [ ! -s $i -o -s $o ] && continue;
    echo "$i => $o";
    cat $i | perl -ne 'chomp; 
       # >NODE_1_length_330253_cov_13.040361
        if($_=~/>(NODE_\d+)_length_(\d+)_cov_([\d\.]+)/){
            $hit = $2>10000 ? 1 : 0;
        }
        print $_,"\n" if $hit;
    ' > $o 
done

fn(){
    i=$1;
    o=../../bigdata/bwa/idx/${i##*/};o=${o%.fasta};o=${o%.fa*};o=${o%.fna*}.fa
    [ -s $o ] || dino mycat $i > $o;wait
    [ -s $o.sa ] || echo "#!/bin/bash
        bwa index $o" | sbatch --mem=24g -c 8 -o $o.sa.out;wait
    [ -s $o.fai ] || echo "#!/bin/bash
        samtools faidx $o " | sbatch  -o $o.fai.out;wait
    [ -s ${o%.fa}.dict ] || echo "#!/bin/bash
        java -jar ../../bigdata/picard.jar CreateSequenceDictionary  R=$o O=${o%.fa}.dict " | sbatch -o ${o%.fa}.dict.out

};export -f fn;

input=(
#../../bigdata/spades/Brachy_Blank/Brachy_Blank_scaffolds_len10k.fasta 
#../../bigdata/spades/Brachy_cells/Brachy_cells_scaffolds_len10k.fasta 
#../../bigdata/spades/Trex_*/*_len10k.fasta 
../../bigdata/spades/Brachy_vessels/Brachy_vessels_scaffolds_len10k.fasta 
)
parallel fn {} ::: ${input[@]}
exit;

input=(
	../../bigdata/leehom/Brachy_Blank.fq.gz
    ../../bigdata/leehom/Brachy_cells.fq.gz
	../../bigdata/leehom/Brachy_c_sedi.fq.gz
	../../bigdata/leehom/Brachy_vessels.fq.gz
	../../bigdata/leehom/Brachy_v_sedi.fq.gz
#	bigdata/leehom/Trex_cells.fq.gz
#	bigdata/leehom/Trex_c_sedi.fq.gz
#	bigdata/leehom/Trex_ExtrBlank.fq.gz
#	bigdata/leehom/Trex_vessels.fq.gz
#	bigdata/leehom/Trex_v_sedi.fq.gz
#bigdata/leehom/ERR5024913.fq.gz
#bigdata/leehom/ERR5032053.fq.gz

)
odir=`realpath ../../bigdata/bwa/results`; mkdir -p $odir
idx=( ../../bigdata/bwa/idx/Brachy_cells_scaffolds_len10k.fa )
gatk=../../bigdata/gatk/gatk-4.6.2.0/gatk

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

	#bwa aln $j $i -t 24 -n 0.01 -l 1000 -o 2 > $o.sai
	#bwa samse $j $o.sai $i -f $o.sam
	#samtools view -q 20 -F0x4 -hb $o.sam | samtools sort - -@ 16 -T $o > $o.bam
	dino gatk-run $o $o.bam $j 16
	#rm $o.sam
	" | sbatch --mem=64g -c 24 --time=100:00:00 -o $o.dedup.rg.bam.out
done
done

