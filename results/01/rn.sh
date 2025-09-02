idir=/mnt/vstor/SOM_GENE_BEG33/data/adna_deweese
odir=$idir/results/01;mkdir -p $odir

wget https://kaiju-idx.s3.eu-central-1.amazonaws.com/2024/kaiju_db_nr_2024-08-25.tgz -O $odir/kaiju_db_nr_2024-08-25.tgz
exit

o=$odir/barcode01
tmp=`mktemp -d `
gunzip -dc $idir/b3_native/B3_Ligation8_sample_24_10_02/no_sample_id/20241002_0830_MN46553_FAZ98854_efb302b0/fastq_pass/barcode01/*.fastq.gz > $tmp/a
dino fastplong -o $o.fastq.gz -j $o.json -i $tmp/a -h $o.html &> $o.log

gunzip -dc $o.fastq.gz | head
