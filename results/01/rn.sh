idir=/mnt/vstor/SOM_GENE_BEG33/data/adna_deweese/

for f in $idir/b3_native/B3_Ligation8_sample_24_10_02/no_sample_id/20241002_0830_MN46553_FAZ98854_efb302b0/fastq_pass/barcode01/*.fastq.gz;do
	echo "$f---------"
	gunzip -dc $f | head ;

done


#fastplong -i $idir/b3_native/B3_Ligation8_sample_24_10_02/no_sample_id/20241002_0830_MN46553_FAZ98854_efb302b0/fastq_pass/barcode01/FAZ98854_pass_barcode01_efb302b0_0516a1be_0.fastq.gz -o o -xyy -j o.json 
#
#fastplong -i $idir/b3_native/B3_Ligation8_sample_24_10_02/no_sample_id/20241002_0830_MN46553_FAZ98854_efb302b0/fastq_pass/barcode01/FAZ98854_pass_barcode01_efb302b0_0516a1be_0.fastq.gz -o o -xyy -j o.json 
#
