
input=(
9913 ## Bos taurus
9606 ## Human
10090 ## Mouse
)


#fna_8=$Data_dir/data_d_vertebrate_mammalian_m_a_chromosome_c_referencegenome_Human_Mouse/input-sequences.fna
#o=$output/data_d_vertebrate_mammalian_m_a_chromosome_c_referencegenome_Human_Mouse; D=vertebrate_mammalian; 
#TInrs="9606,10090"
#mamba activate dino_env

#centrifuge-download -o library -m -d "$D" -a "Chromosome" -t $TInrs -c 'reference genome' refseq > $o/seq2taxid.map


run-centrifuge(){
	echo "#!/bin/bash
	mkdir -p ${o%/*}
	#centrifuge -p 8 -x $x -1 $i -2 ${i/_R1/_R2} --report-file $o.tsv  > $o.txt
	centrifuge -p 8 -x $x -U $i,${i/_R1/_R2} --report-file $o.tsv  > $o.txt
	" 
}

centrifuge-test(){
#ref:	https://ccb.jhu.edu/software/centrifuge/manual.shtml
#Conversion	table	ex.conv:

cf_ct="Seq1	11
Seq2	12
Seq3	13
Seq4	11
"

#Taxonomy	tree	ex.tree:
cf_tr="1	|	1	|	root
10	|	1	|	kingdom
11	|	10	|	species
12	|	10	|	species
13	|	1	|	species
"

#Name	table	ex.name:
cf_nt="1	|	root	|	|	scientific	name	|
10	|	Bacteria	|	|	scientific	name	|
11	|	Bacterium_A	|	|	scientific	name	|
12	|	Bacterium_B	|	|	scientific	name	|
12	|	Some_other_species	|	|	scientific	name	|
"
#Reference	sequences	ex.fa:
cf_rs=">Seq1
AAAACGTACGA
>Seq2
AAAACGTACGA
>Seq3
AAAACGTACGA
>Seq4
AAAACGTACGA
"
echo "$cf_cv" > tmp.a
echo "$cf_tr" > tmp.b
echo "$cf_nt" > tmp.c
echo "$cf_rs" > tmp.d

#centrifuge-build --conversion-table <( echo "$cf_cv" ) --taxonomy-tree <( echo "$cf_tr" ) \
#	--name-table <( echo "$cf_nt" ) <( echo "$cf_rs" )  ex 
centrifuge-build --conversion-table tmp.a  --taxonomy-tree tmp.b \
	--name-table tmp.c tmp.d  tmp.ex
ls tmp.ex
rm tmp.*
}


