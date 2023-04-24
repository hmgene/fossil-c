bwa-aln(){
usage="$FUNCNAME <ref.fa> <short_read.fq1> <short_read.fq2> <prefix> [options]"
if [ $# -lt 4 ];then echo "$usage"; return; fi
local ref=$1;
local fq1=$2;
local fq2=$3;
local o=$4;
local t=16; ## #threads 
local op=" -l 1024 -n 0.01 -o 2 ${@:5}"
	bwa aln $op $ref $fq1 > $o.1.sai 
	bwa aln $op $ref $fq2 > $o.2.sai 
	bwa samse $ref $o.1.sai $fq1 > $o.1.sam
	bwa samse $ref $o.2.sai $fq2 > $o.2.sam
	bwa sampe $ref $o.1.sai $o.2.sai $fq1 $fq2 > $o.pe.sam
}

