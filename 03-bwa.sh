
#bwa/allMis1/allMis1.fa.gz.sa  bwa/danRer11/danRer11.fa.gz.sa  bwa/hg38/hg38.fa.gz.sa        bwa/sCam/sCam.fa.gz.sa
#bwa/anoCar2/anoCar2.fa.gz.sa  bwa/galGal6/galGal6.fa.gz.sa    bwa/ornAna2/ornAna2.fa.gz.sa

rr=( allMis1 danRer11 hg38 anoCar2 galGal6 sCam )
t=16 ## threads
mem=64g
odir=bw
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
