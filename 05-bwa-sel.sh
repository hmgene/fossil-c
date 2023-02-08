ff=(
#fq3/bra_cells_merged_R1.fastq.gz
#fq3/bra_vessels_merged_R1.fastq.gz
#fq3/trex_cells_R1.fastq.gz
#fq3/trex_vessels_R1.fastq.gz
#fq3/ost_cc_R1.fastq.gz
#fq3/ost_ep_R1.fastq.gz
#fq3/ost_om_R1.fastq.gz
fq3/cara_bone_R1.fastq.gz
fq3/cara_fossil_R1.fastq.gz
fq3/cara_muscle_R1.fastq.gz
)

rr=( allMis1 danRer11 hg38 anoCar2 galGal6 sCam )
odir=bw1

t=16 ## threads
mem=64g
qt="40:00:00"

mkdir -p $odir
#-l 1027 : disabled seed
igvtools=/mnt/rstor/SOM_GENE_BEG33/software/IGVTools_2.3.98
for f1 in ${ff[@]};do
        f2=${f1/_R1/_R2}; if [ ! -f $f2 ];then f2=""; fi
        s=${f1##*/};s=${s%_R1.fastq.gz};
        for r in ${rr[@]};do
                r1=../data/ucsc/$r/$r.fa.gz
                        o="$odir/$s@$r"
                        echo $o
                if [ -f $o.bam ];then
                        echo "exists $o.bam";
                        continue;
                fi
                        cat<<-eof | sbatch -c $t --mem=$mem -t $qt
                        #!/bin/bash -l
                        module load bwa
                        module load samtools
                        bwa mem -P -B3 $r1 $f1 $f2 -t $t > $o.sam;
                        samtools view -F 0x4 -hb $o.sam | samtools sort - -@ $t -T $o > $o.bam
                        rm $o.sam
                        samtools index $o.bam
                        java -Xmx$mem -jar $igvtools/igvtools.jar count $o.bam $o.tdf ${r1%.gz}
                        eof
        done

done
