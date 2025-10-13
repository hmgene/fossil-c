input=(
# NCBI geenome
## Varanus komodoensis
"61221 komodo_dragon https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/004/798/865/GCF_004798865.1_ASM479886v1/GCF_004798865.1_ASM479886v1_genomic.fna.gz"
## Brown anole (Anolis sagrei)
"38937 brown_anole https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/037/176/765/GCF_037176765.1_rAnoSag1.mat/GCF_037176765.1_rAnoSag1.mat_genomic.fna.gz"
## Bearded dragon (Pogona vitticeps)
"103695 bearded_dragon https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/047/335/585/GCF_047335585.1_Pvi2.1/GCF_047335585.1_Pvi2.1_genomic.fna.gz"
## Peregrine falcon (Falco peregrinus)
"8954 falcon https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/634/155/GCF_023634155.1_bFalPer1.pri/GCF_023634155.1_bFalPer1.pri_genomic.fna.gz"
## Crocodile
"8502 crocodile https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Crocodylus_porosus/latest_assembly_versions/GCF_001723895.1_CroPor_comp1/GCF_001723895.1_CroPor_comp1_genomic.fna.gz"
##Common ostrich (Struthio camelus)
"8801 ostrich https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Struthio_camelus/latest_assembly_versions/GCF_040807025.1_bStrCam1.hap1/GCF_040807025.1_bStrCam1.hap1_genomic.fna.gz"

# UCSC genome
"28377 lizard bigdata/ucsc/fa/anoCar2.fa"
"9031 chicken bigdata/ucsc/fa/galGal6.fa"
"8496 alligator bigdata/ucsc/fa/allMis1.fa"
"10090 mouse  bigdata/ucsc/fa/mm10.fa.gz"
"9913 cow bigdata/ucsc/fa/bosTau9.fa.gz"
"9785 elephant bigdata/ucsc/fa/loxAfr3.fa.gz"
)

for line in "${input[@]}"; do
    read -r taxid species f <<< "$line"
        o=bigdata/genome/$species.fna.gz
    if [ -f $o ];then
        echo "$o exists!";
    else
        if curl --head --silent --fail "$f" > /dev/null; then
			echo "#!/bin/bash
			wget -c $f -O $o.gz; " | sbatch -J dn_$species
		elif [ -s $f ];then 
			echo "$f exists!"
		else
            echo "$f not exists!";
	 	fi;
    fi
done
