
ss=(
trex_cells
trex_vessels
bra_cells_merged
bra_vessels_merged
ost_cc
ost_ep
ost_om
cara_bone
cara_muscle
cara_fossil
)

rr=( allMis1 danRer11 hg38 anoCar2 galGal6 sCam )


tt=(
/mnt/rstor/SOM_GENE_BEG33/users/hxk728/pj/fossil-c/06-trex/mt/bra_cells_merged.win.tt
/mnt/rstor/SOM_GENE_BEG33/users/hxk728/pj/fossil-c/06-trex/mt/bra_vessels_merged.win.tt
/mnt/rstor/SOM_GENE_BEG33/users/hxk728/pj/fossil-c/06-trex/mt/trex_cells.win.tt
/mnt/rstor/SOM_GENE_BEG33/users/hxk728/pj/fossil-c/06-trex/mt/trex_vessels.win.tt
)

odir=fq3
mkdir -p $odir
for s in ${ss[@]};do
        t=$odir/$s@hg38
        grep hg38 mt/$s.win.tt | grep -v "," | cut -f 1 > $t
        f1=fq1/Qgxy/${s}_R1.fastq.gz
        if [ ! -f $f1 ];then
                f1=${f1/fq1/fq2}
                if [ !  -f $f1 ];then
                        continue;
                fi
        fi
        f2=${f1/_R1/_R2};
        o1=$odir/${s}_R1.fastq.gz
        o2=$odir/${s}_R2.fastq.gz
        echo "#!/bin/bash
        . ../tools/src.sh;
        fq-fil-id $f1 $t -v | gzip -c > $o1
        " | sbatch --mem=64g
        echo "#!/bin/bash
        . ../tools/src.sh;
        fq-fil-id $f2 $t -v | gzip -c > $o2
        " | sbatch --mem=64g

done
