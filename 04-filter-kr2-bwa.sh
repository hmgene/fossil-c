samples=(
        Brachy_Blank
        Brachy_cells
 #       Brachy_c_sedi
 #       Brachy_vessels
 #       Brachy_v_sedi
 #       Trex_cells
 #       Trex_c_sedi
 #       Trex_ExtrBlank
 #       Trex_vessels
 #       Trex_v_sedi
)
ft(){
    dino fq-fil-id $1 <( cat $2 | awk '$1=="U"' | cut -f 2 ) | tee >( sed -n '0~4p' | wc -l > $3.n ) | gzip -c > $3
};export -f ft

odir=bigdata/filt
mkdir -p $odir
for s in ${samples[@]};do
    f1=bigdata/kr2/results/$s.k2_output.txt
    f2=bigdata/kr2/nt_db/results/$s.k2_output.txt
    fq=bigdata/leehom/$s.fq.gz 
    o=$odir/$s.fq.gz
    echo "#!/bin/bash
        ft $fq <( cat $f1 $f2 ) $o 
    " | sbatch --mem=128g -o $o.out -J $s
done
