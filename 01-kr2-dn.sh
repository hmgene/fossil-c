#!/bin/bash
# ref : https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
set -euo pipefail
input_lib=(
	## add domains to setup kraken2-db (plasmid is added later)
	## plasmid data : https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plasmid/
	archaea
	bacteria
	human
	#plant
	#plasmid
	viral
	fungi
	protozoa
	UniVec_Core
)

input_added=(
#"9031 chicken bigdata/ucsc/fa/galGal6.fa"
#"8496 alligator bigdata/ucsc/fa/allMis1.fa"
#"8502 crocodile https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Crocodylus_porosus/latest_assembly_versions/GCF_001723895.1_CroPor_comp1/GCF_001723895.1_CroPor_comp1_genomic.fna.gz"
#"8801 ostrich https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Struthio_camelus/latest_assembly_versions/GCF_040807025.1_bStrCam1.hap1/GCF_040807025.1_bStrCam1.hap1_genomic.fna.gz"
#"28377 lizard bigdata/ucsc/fa/anoCar2.fa"
#"10090 mouse  bigdata/ucsc/fa/mm10.fa.gz"
#"9913 cow bigdata/ucsc/fa/bosTau9.fa.gz"
#"9785 elephant bigdata/ucsc/fa/loxAfr3.fa.gz"
#Varanus komodoensis
"61221 komodo_dragon bigdata/genome/komodo_dragon.fna.gz"
#Brown anole (Anolis sagrei)
"38937 brown_anole bigdata/genome/brown_anole.fna.gz"
#Bearded dragon (Pogona vitticeps)
"103695 bearded_dragon bigdata/genome/bearded_dragon.fna.gz"
#Peregrine falcon (Falco peregrinus)
"8954 falcon bigdata/genome/falcon.fna.gz"
)

db=bigdata/kr2

jj=()
if [ -d $db/taxonomy/ ];then
	echo "$db/taxonomy exists"
else
	j=$( echo "#!/bin/bash
	set -euo pipefail
	dino kraken2-build --download-taxonomy --db $db --threads 8"  | sbatch -J taxo_$db  )
	jj+=($j)
fi

## download domain libraries

jj_str=$(IFS=:; echo "${jj[*]}"); dopt="";if [ -n "$jj_str" ];then dopt="--dependency=afterok:$jj_str";fi

for d in ${input_lib[@]};do
	o=$db/library/$d/library.fna
	if [ -s $o ];then
		echo "$o lib exists"
	else
	 	echo "#!/bin/bash
		set -euo pipefail
		dino kr2-dn-lib $d $db
		" | sbatch $dopt -J dn_$d
	fi
done

for line in "${input_added[@]}"; do
    read -r txid species url <<< "$line"
    if [ `dino kr2-is-txid $db $txid` ];then
		echo "$txid exists in the lib";
    else
		echo "#!/bin/bash
		set -euo pipefail
		dino kr2-add-genome $url $species $txid $db
		" | sbatch $dopt --mem=16g -c 8 -J dn_$species 
    fi
done

