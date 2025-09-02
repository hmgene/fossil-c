#https://github.com/bioinformatics-centre/kaiju?tab=readme-ov-file

kaiju-dn(){
local input=(
	https://kaiju-idx.s3.eu-central-1.amazonaws.com/2024/kaiju_db_nr_2024-08-25.tgz
)
parallel "echo wget {} -O ${1:-/mnt/vstor/SOM_GENE_BEG33/data/adna_deweese/results/01/}/{/}" ::: ${input[@]}
}

kaiju-run(){
	kaiju -z 25 -t nodes.dmp -f kaiju_db.fmi -i inputfile.fastq -o kaiju.out
}
