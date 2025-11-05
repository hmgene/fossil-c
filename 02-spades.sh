# ref : https://archaeogenetics.readthedocs.io/en/latest/4_ReadsMapping_v2.html
input=(
#	bigdata/leehom/Brachy_Blank.fq.gz
	bigdata/leehom/Brachy_cells.fq.gz
#	bigdata/leehom/Brachy_c_sedi.fq.gz
#	bigdata/leehom/Brachy_vessels.fq.gz
#	bigdata/leehom/Brachy_v_sedi.fq.gz
#	bigdata/leehom/Trex_cells.fq.gz
#	bigdata/leehom/Trex_c_sedi.fq.gz
#	bigdata/leehom/Trex_ExtrBlank.fq.gz
#	bigdata/leehom/Trex_vessels.fq.gz
#	bigdata/leehom/Trex_v_sedi.fq.gz

)
odir=`realpath bigdata/spades`; mkdir -p $odir

for i in ${input[@]};do 
	s=${i##*/};s=${s%.fq.gz*};
	o=$odir/$s; mkdir -p $o 
    echo "#!/bin/bash -l
    mamba activate dino_env
    /mnt/vstor/SOM_GENE_BEG33/fossil-c/bigdata/tools/SPAdes-4.2.0-Linux/bin/spades.py -s $i -o $o  --careful -k 21,33,55 -t 8 --only-assembler
    " | sbatch -p smp --mem=256g -c 32 --time=100:00:00 -o $o/out
done
