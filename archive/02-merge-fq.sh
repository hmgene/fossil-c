# merge bra_cells and bra_vessels
qq=( QLG QLg QLgx QLgxy Qgxy gxy )
for q in ${qq[@]};do
if [ $q != "Qgxy" ];then continue; fi
for c in cells vessels;do
        o=fq2/$q/bra_${c}_merged
        mkdir -p ${o%/*}
        echo $o
        {
        for f1 in fq1/$q/bra*$c*R1.fastq.gz;do
                s=${f1##*/};s=${s%_R1.fastq.gz};
                zcat $f1 | fq-sfx - $s
        done
        } | gzip -c > ${o}_R1.fastq.gz
        {
        for f2 in fq1/$q/bra*$c*R2.fastq.gz;do
                s=${f2##*/};s=${s%_R2.fastq.gz};
                zcat $f2 | fq-sfx - $s
        done
        } | gzip -c > ${o}_R2.fastq.gz
        #zcat fq1/$q/bra*$c*R1.fastq.gz | fq-sfx - | gzip -c > ${o}_R1.fastq.gz
        #zcat fq1/$q/bra*$c*R2.fastq.gz | fq-sfx - | gzip -c > ${o}_R2.fastq.gz
done
done
