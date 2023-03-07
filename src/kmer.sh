

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
usage="$FUNCNAME <kmer.fa> [<w=1>] [<q=1>]"
# q-mer density for k-mer sequence 
#ref: https://www.nature.com/articles/s41598-021-93154-3
cat $1  | perl -e 'use strict; my $W='${2:-1}'; my $Q='${3:-1}';
	my $id="";
	my %r=();
	my %m=( A=>"1000", C=>"0100", G=>"0010", T=>"0001" ); 
	while(<STDIN>){chomp;
		if($_=~/^>/){ $id=substr($_,1); 
		}else{
			my $s=$_;
			foreach my $i (0..(length($s) - $W)){
				my %q=();
				foreach my $j (0..($W-$Q)){
					$q{ substr($s,$i+$j,$Q) } += 1/$W;
				}
				foreach my $k ( keys %q){
					print join("\t",$s,"$k$i",$q{$k}),"\n";
				}
			}
		}
	}
'
}

q-gram-test(){
echo ">1
AACCGT" | q-gram - 3 2
}

q-gram-pca-plot(){
cat<<-eof
i="o";
tt=read.table(i,header=T);
library(stringr)
r=as.factor(sapply(str_split(tt[,1],"\\."),function(x) x[2]))
s=as.factor(sapply(str_split(tt[,1],"\\."),function(x) x[1]))

pc <- prcomp(tt[,-1], center = TRUE, scale. = TRUE)
y=predict(pc); 
plot(y[,1],y,col=r,pch=levels(s))


eof
}
