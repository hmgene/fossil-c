input=(
#/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_Blank_S9_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_cells_S5_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_c_sedi_S7_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_vessels_S6_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_v_sedi_S8_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_cells_S10_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_c_sedi_S12_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_ExtrBlank_S14_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_vessels_S11_L002_R1_001.fastq.gz
/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Trex_v_sedi_S13_L002_R1_001.fastq.gz
)

for f1 in ${input[@]};do
    n=${f1##*/};n=${n%_S*};n=${n%_?.fastq.gz};
    f2=${f1/_R1/_R2}
    for x in QGL GL L xL xyL xy ;do
        output=bigdata/fastp/$x;mkdir -p $output;
        o=$output/$n; o1=${o}_R1.fq.gz; o2=${o1/_R1/_R2};
        if [ -s $o.fastp.json ];then
            echo "$o.fastp.json, $o1 and $o2 exist! skip "
        else
            mkdir -p ${o%/*}
            if [ ${f%ERR*} == $f ];then
                echo "#!/bin/bash 
                set -euo pipefail
                fastp -i $f1 -I $f2 -o $o1 -O $o2  \
                    --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
                    --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
                    --umi --umi_loc=read1 --umi_len=9 \
                    --json $o.fastp.json --html $o.fastp.html --thread 8 -$x
                " | sbatch --mem=16g -c 9 -o $output/$n.out
            fi
        fi
    done
done      
