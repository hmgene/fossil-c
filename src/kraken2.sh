
kr2-fa(){
usage="
- modify to kr2 styleheader  
usge: $FUNCNAME <in.fa> <taxid> > <out.fa>
"; if [ $# -lt 2 ];then echo "$usage";return;fi
	cat $1 | awk -v taxid=$2 '/>/{ print ">kraken:taxid|"taxid"|"substr($0,2);next}{print}'
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


