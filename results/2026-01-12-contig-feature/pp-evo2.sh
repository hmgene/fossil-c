#cat  ../../bigdata/augustus/Brachy_cells.gff  | grep -v "^#" | hm gff2bed12 - |\
#cut -f 1,10 > chrom_nexon.txt 
i=`sort -nrk2 chrom_nexon.txt | head -n 1 | cut -f 1`
#cat ../../bigdata/spades/Brachy_cells/scaffolds.fasta  |\
#perl -ne 'chomp;if($_=~/>/){ print "\n";} print $_;' |\
#grep $i > $i.fa 
#
grep $i ../../bigdata/augustus/Brachy_cells.gff > $i.gff 

