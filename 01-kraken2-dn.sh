#!/bin/bash
# ref : https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
set -euo pipefail
input_control=(
	## add domains to setup kraken2-db (plasmid is added later)
	## plasmid data : https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plasmid/
#	archaea
#	bacteria
#	human
#	#plant
#	plasmid
#	viral
#	fungi
#	protozoa
#	UniVec_Core
)

input_target=(
#"9031 chicken bigdata/ucsc/fa/galGal6.fa"
#"8496 alligator bigdata/ucsc/fa/allMis1.fa"
#"8502 crocodile https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Crocodylus_porosus/latest_assembly_versions/GCF_001723895.1_CroPor_comp1/GCF_001723895.1_CroPor_comp1_genomic.fna.gz"
#"8801 ostrich https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Struthio_camelus/latest_assembly_versions/GCF_040807025.1_bStrCam1.hap1/GCF_040807025.1_bStrCam1.hap1_genomic.fna.gz"
#"28377 lizard bigdata/ucsc/fa/anoCar2.fa"
"10090 mouse  bigdata/ucsc/fa/mm10.fa.gz"
"9913 cow bigdata/ucsc/fa/bosTau9.fa.gz"
"9785 elephant bigdata/ucsc/fa/loxAfr3.fa.gz"
)

db=bigdata/kr2_ctr

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
for d in ${input_control[@]};do
	o=$db/library/$d/library.fna
	if [ -s $o ];then
		echo "$o exists"
	else
	 	echo "#!/bin/bash
		set -euo pipefail
		dino kr2-dn-lib $d $db
		" | sbatch $dopt -J dn_$d
	fi
done

for line in "${input_target[@]}"; do
    read -r taxid species url <<< "$line"
    	o=bigdata/genome/$species.fna
    	if [ -f $o ];then 
		echo "$o exists!"; 
	else
		echo "#!/bin/bash
		set -euo pipefail
		dino kr2-add2lib $url $species $taxid $db
		" | sbatch $dopt --mem=16g -c 8 -J dn_$species 
	fi
done

