
input=(
bigdata/carpedeam/Brachy_Blank.unc.fa   bigdata/carpedeam/Brachy_vessels.unc.fa  bigdata/carpedeam/Trex_c_sedi.unc.fa     bigdata/carpedeam/Trex_v_sedi.unc.fa
bigdata/carpedeam/Brachy_cells.unc.fa   bigdata/carpedeam/Brachy_v_sedi.unc.fa   bigdata/carpedeam/Trex_ExtrBlank.unc.fa
bigdata/carpedeam/Brachy_c_sedi.unc.fa  bigdata/carpedeam/Trex_cells.unc.fa      bigdata/carpedeam/Trex_vessels.unc.fa
)

for i in ${input[@]};do
    n=${i##*/};n=${n%.fa};
    o=bigdata/blast/results/$n
    mkdir -p ${o%/*}
echo "#!/bin/bash
    bigdata/blast/ncbi-blast-2.17.0+/bin/blastn   \
     -db bigdata/blast/nt/nt  -query $i  -out $o.tsv \
     -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore'
" | sbatch --mem=24g -c4 -J $n.bl
done

