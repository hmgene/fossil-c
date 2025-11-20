input=(
Pinus_taeda,3352
Komagataella,460519
)
output=../../bigdata/bwa/idx
for i in ${input[@]};do
    n=`echo $i | cut -d"," -f 1`
    t=`echo $i | cut -d"," -f 2`
    o=$output/$n
    [ -s $o.fa ] || \
    echo "#!/bin/bash
    grep -w $t ../../bigdata/kr2/nt_db/seqid2taxid.map | cut -f 1 >  $o.acc
    cat ../../bigdata/kr2/nt_db/library/*/*.fna  | dino fa-filt - $o.acc > $o.fa
    " | sbatch --mem=64g --time=100:00:00 -o $o.out -e $o.err -J fa_${n}
done
