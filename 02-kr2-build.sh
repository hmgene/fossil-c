#!/bin/bash

dbs=( 
	bigdata/kr2
)

for db in ${dbs[@]};do
	echo "#!/bin/bash
	set -euo pipefail
	dino kraken2-build  --db $db --threads 16 --build
	"  | sbatch --mem=194g -p smp -c 16 -J build_$db --time=100:00:00
done

