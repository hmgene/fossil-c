db=bigdata/kr2_v2
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

for f in ${input[@]};do
        n=${f##*/};n=${n%.fq.gz};
        o=$db/results/$n
        mkdir -p ${o%/*}

	#[ -s $o.k2_report.txt ] || \
	echo "#!/bin/bash 
	dino kraken2 --db $db --report $o.k2_report.txt --report-minimizer-data \
    	--output $o.k2_output.txt $f
	" | sbatch --mem=256g -c 24 -p smp
done


