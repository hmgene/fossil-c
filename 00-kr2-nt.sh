nt_db=bigdata/kr2/nt_db
mkdir -p $nt_db
if [ ! -s  $nt_db/hash.k2d  ];then
echo "#!/bin/bash
mamba activate dino_env
dino kraken2-build --download-taxonomy --db $nt_db
dino kraken2-build --download-library nt --db $nt_db
dino kraken2-build --build --db $nt_db --threads 8 --fast-build
" #| sbatch --mem=1024g -c 24 -p smp -J nt --time=100:00:00 -o $nt_db/out
fi
