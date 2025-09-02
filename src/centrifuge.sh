
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
