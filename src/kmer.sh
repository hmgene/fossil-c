

run-jellyfish(){
usage="$FUNCNAME <fa> <k> <o>";
if [ $# -lt 1 ];then echo "$usage";return;fi
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

q-gram(){
usage="$FUNCNAME <kmer.fa> <bsize>"
# q-mer density for k-mer sequence 
#ref: https://www.nature.com/articles/s41598-021-93154-3
cat $1  | perl -e 'use strict; my $B='${2:-1}';
	my $id="";
	my %r=();
	my %m=( A=>"1000", C=>"0100", G=>"0010", T=>"0001" ); 
	while(<STDIN>){chomp;
		if($_=~/^>/){ $id=substr($_,1); 
		}else{
			print $id;
			map { print "\t",join("\t",split//,$m{$_});} split //,$_;
			print "\n";
		}
	}
'
}

q-gram-test(){
echo ">1
AACCGT" | q-gram - 4
}
