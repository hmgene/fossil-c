

run-jellyfish(){
usage="$FUNCNAME <fa> <k> <o>";
local k=$2;
local o=$3;
cat $1 | fo jellyfish count -s 100000000 -C -m $k -t 1 -o $o.db /dev/stdin
fo jellyfish dump $o.db > $o
#java -classpath ./bin/ GetFreKmerWithThreshold /mnt/rstor/SOM_GENE_BEG33/users/hxk728/pr/RepAHR/trex/jf_zhang_kmers.fasta 11 /mnt/rstor/SOM_GENE_BEG33/users/hxk728/pr/RepAHR/trex/frequent_kmers_11.fasta
}

run-jellyfish-test(){
echo ">1
ACGTAACGT" | run-jellyfish - 3 tmp
}
