
kr2-fq-class(){
echo "read https://jodyphelan.gitbook.io/tutorials/ngs/kraken2"
}

kr2-summ(){
# ref : https://bioinformaticsworkbook.org/dataAnalysis/Metagenomics/Kraken.html#gsc.tab=0 
#generates list of only those with .01% of reads and removed nematodes from the report

for f in *report; do echo "awk '\$1>0 && \$3>100' "$f" |uniq|sort -k1,1nr |grep -v \"Meloidogyne\" |grep -v \"Heterodera\" |grep -v \"Globodera\" |grep -v \"Bursaphelenchus\" |grep -v \"Ditylenchus\" >"$f".summary" ;done >summarizer.sh
sh summarizer.sh

#example output from the script above.
#################################
awk '$1>0 && $3>100' Ga1-pol-1_S1_L004_R1_001.fastq.gz.report |uniq|sort -k1,1nr|grep -v "Meloidogyne" |grep -v "Heterodera" |grep -v "Globodera" |grep -v "Bursaphelenchus" |grep -v "Ditylenchus"  >Ga1-pol-1_S1_L004_R1_001.fastq.gz.report.summary
#################################
}



kr2-dn-lib(){
	usage="$FUNCNAME <library> <db> [<threads>=8]";if [ $# -lt 1 ];then echo "$usage";return;fi
	if [ $1 == "plasmid" ];then 
		o=bigdata/genome/plasmid.fna
		if [ ! -s $o ];then
			mkdir -p ${o%.fna}
			cd ${o%.fna}
			wget -r -np -nH --cut-dirs=3 -A "*genomic.fna.gz" ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/plasmid/
			gunzip -dc *genomic.fna.gz | dino kr2-fa - 36549 > library.fna
			cd -
		fi
		dino kraken2-build --add-to-library $o --db $2 
	else
		o=bigdata/$2/library/$1/library.fna
		if [ -s $o ];then
			echo "$o exists!"
		else
			dino kraken2-build --download-library $1 --db $2 --threads ${3:-8}
		fi
	fi
		
}

kr2-dn-taxonomy(){
usage="$FUNCNAME <db>";if [ $# -lt 1 ];then echo "$usage";return;fi
	local d=$1;
	if [ -d $d/taxonomy/ ];then
		echo "$d/taxonomy exists"
	else
		echo "building .. $d/taxonomy"
		dino kraken2-build --download-taxonomy --db $db --threads $p
		echo "done buiding .. $d"
	fi
}

kr2-add2lib(){
	usage="$FUNCNAME <fa|url> <species_name> <taxid> <krakendb> [output=bigdata/genome/<species_name>.fna]> [threds=8]";
	if [ $# -lt 4 ];then echo "$usage";return;fi
	f=$1;s=$2;t=$3;d=$4;o=${5:-bigdata/genome/$s.fna};p=${6:-8}
	if [ -s $o ];then
		echo "$o exists"
	else
		mkdir -p ${o%/*}
		if [ -s $f ];then
			dino kr2-fa $f $t > $o
		elif curl --head --silent --fail "$f" > /dev/null; then
			wget -c $f -O $o.gz 
			dino kr2-fa $o.gz $t > $o
		else
			echo "$f not exists!"
			return 
		fi
	fi

	o2=$d/library/$s/library.fna
	if [ -s $o2 ];then 
		echo "$o2 exists!"
	else
		echo "building .. $o2"
		dino kraken2-build --add-to-library $o --db $d 
		echo "done .. $o2"
	fi
}


kr2-fa(){
usage="
- modify to kr2 styleheader  
usge: $FUNCNAME <in.fa> <taxid> > <out.fa>
"; if [ $# -lt 2 ];then echo "$usage";return;fi
	dino mycat $1 | awk -v taxid=$2 '/>/{ print ">kraken:taxid|"taxid"|"substr($0,2);next}{print}'
}
kr2-build(){
usage="$FUNCNAME <db=bigdata/kr2/db> [thread=8]";if [ $# -lt 1 ];then echo "$usage";return;fi 
dino kraken2-build \
  --db ${1:-bigdata/kr2/db} \
  --kmer-len 21 \
  --minimizer-len 15 \
  --use-spaced-seeds \
  --spaced-seed-mask 111101110111011101111 \
  --threads ${2:-8} \
  --build
}


