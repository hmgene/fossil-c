# ref : https://archaeogenetics.readthedocs.io/en/latest/4_ReadsMapping_v2.html
input=(
bigdata/centrifuge/results/Brachy_Blank.unc.fq.gz
#bigdata/centrifuge/results/Brachy_cells.unc.fq.gz
#	bigdata/leehom/Brachy_Blank.fq.gz
#	bigdata/leehom/Brachy_cells.fq.gz
#	bigdata/leehom/Brachy_c_sedi.fq.gz
#	bigdata/leehom/Brachy_vessels.fq.gz
#	bigdata/leehom/Brachy_v_sedi.fq.gz
#	bigdata/leehom/Trex_cells.fq.gz
#	bigdata/leehom/Trex_c_sedi.fq.gz
#	bigdata/leehom/Trex_ExtrBlank.fq.gz
#	bigdata/leehom/Trex_vessels.fq.gz
#	bigdata/leehom/Trex_v_sedi.fq.gz

)
odir=`realpath bigdata/carpedeam`; mkdir -p $odir

for i in ${input[@]};do 
	s=${i##*/};s=${s%.fq.gz*};
	o=$odir/$s.fa; 
    o_tmp=$odir/${s}_tmp; mkdir -p $o_tmp
    o_dam=$odir/${s}_dmg; 
    if [ -s $o.fa ];then echo "$o.fa exists!"; continue; fi

    echo "#!/bin/bash -l
    mamba activate dino_env
    carpedeam ancient_assemble <( gunzip -dc $i | dino fq-trim-n - )  $o $o_tmp --threads 4 # --ancient-damage $o_tmp/dmg
    " | sbatch -p smp --mem=2000g -c 16 --time=100:00:00 -o $o.out

done
