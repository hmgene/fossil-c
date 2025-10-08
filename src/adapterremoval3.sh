#!/bin/bash
ref="https://adapterremoval.readthedocs.io/en/latest/"

input_fq=/mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_Blank_S9_L002_R1_001.fastq.gz

# dino adapterremoval3 $@
# or
adrm(){
	usage="$FUNCNAME <fq1> <fq2> <outdir/name>"
	if [ $# -lt 2 ];then echo "$usage";return;fi
	dino adapterremoval3 --in-file1 $1  --in-file2 $2  --out-prefix $3 --merge
}

