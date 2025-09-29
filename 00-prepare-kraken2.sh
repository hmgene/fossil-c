#!/bin/bash
# ref : https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
set -euo pipefail

db=bigdata/kr2_v2
input_conta=(
	## add domains to setup kraken2-db
	archaea
	bacteria
	human
	plasmid
	viral
	fungi
	#plant
	protozoa
	UniVec
	UniVec_Core
)
input_target=(
	"9031 chicken https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Gallus_gallus/latest_assembly_versions/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna.gz"
	"8501 crocodile https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Crocodylus_porosus/latest_assembly_versions/GCF_001723895.1_CroPor_comp1/GCF_001723895.1_CroPor_comp1_genomic.fna.gz"
	"8944 ostrich https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Struthio_camelus/latest_assembly_versions/GCF_040807025.1_bStrCam1.hap1/GCF_040807025.1_bStrCam1.hap1_genomic.fna.gz"
)
threads=24

run-sbatch(){
jid1=$(sbatch --parsable --mem=64g -c $threads -J dino_tax <<EOF
#!/bin/bash
set -euo pipefail
[ -d $db ] || dino kraken2-build --download-taxonomy --db "$db" --threads "$threads"
EOF
)
echo "[INFO] Taxonomy download submitted: $jid1"

lib_jids=()
for d in "${input[@]}"; do
    jid=$(sbatch --parsable --dependency=afterok:$jid1 --mem=64g -c $threads -J dino_lib_$d <<EOF
#!/bin/bash
set -euo pipefail
[ -d $db/library/$d ] || dino kraken2-build --download-library "$d" --db "$db" --threads "$threads"
EOF
)
    lib_jids+=($jid)
    echo "[INFO] Library $d submitted: $jid"
done

dep_string=$(IFS=:; echo "${lib_jids[*]}")
jid3=$(sbatch --parsable --dependency=afterok:$dep_string -p smp --mem=256g -p smp -c $threads -J dino_build <<EOF
#!/bin/bash
set -euo pipefail
[ -s $db/hash.k2d ] && [ -s $db/opts.k2d ] && [ -s $db/taxo.k2d ] || dino kr2-build $db $threads
EOF
)
echo "[INFO] DB build submitted: $jid3"
}

run-bash(){
	## contaminant  species
	#echo "#!/bin/bash
	#dino kraken2-build --download-taxonomy --db $db --threads 16 " #| sbatch --mem-64 -c 24
	#for d in ${input[@]};do
	#	[ -d $db/library/$d ] || echo "#!/bin/bash
	#	dino kraken2-build --download-library $d --db $db --threads 16 " #| sbatch --mem=64g -c 24
	#done

	## target species

	w=bigdata/genome
#	jids=()
#	for line in "${input_target[@]}"; do
#	    read -r taxid species url <<< "$line"
#	    jid=$(sbatch --parsable --mem=64g -c $threads -J ${species}_add <<-EOF
#		#!/bin/bash
#		set -euo pipefail
#		[ -s $w/${species}.fna.gz ] || wget -c $url -O $w/${species}.fna.gz
#		[ -s $w/${species}.fna ] || gunzip -dc $w/${species}.fna.gz | dino kr2-fa - $taxid  > $w/${species}.fna  
#		dino kraken2-build --add-to-library $w/${species}.fna --db $db 
#EOF
#)
#	    jids+=($jid)
#	done
	dep_j=$(IFS=:; echo "${jids[*]}")
	echo $dep_j
	#jid=$(sbatch --parsable --dependency=afterok:$dep_j --mem=256g -p smp -c $threads -J build <<-EOF 
	jid=$(sbatch --parsable --mem=256g -p smp -c $threads -J build <<-EOF 
	#!/bin/bash
	set -euo pipefail
	dino kraken2-build  --db $db \
		--kmer-len 21  --minimizer-len 15  --minimizer-spaces 3  \
		--threads 20 --build  --fast-build  --no-masking
EOF
)
	echo $jid
}
run-bash
