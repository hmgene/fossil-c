#!/bin/bash
# ref : https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown
set -euo pipefail

db=bigdata/kr2
input=(
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
threads=16

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
[ -s $db/hash.k2d ] && [ -s $db/opts.k2d ] && [ -s $db/taxo.k2d ] || dino kraken2-build --build --db "$db" --threads "$threads"
EOF
)
echo "[INFO] DB build submitted: $jid3"
}

run-bash(){
	[ -d $db ] || echo "#!/bin/bash
	dino kraken2-build --download-taxonomy --db $db --threads 16 " #| sbatch --mem-64 -c 24

	for d in ${input[@]};do
		[ -d $db/library/$d ] || echo "#!/bin/bash
		dino kraken2-build --download-library $d --db $db --threads 16 " #| sbatch --mem=64g -c 24
	done
	echo "#!/bin/bash
	dino kraken2-build --build --db $db --threads 20
	dino kraken2-build --clean --db $db
	" | sbatch --mem=256g -c 24 -p smp
}
run-bash
