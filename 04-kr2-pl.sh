input=( 
#brachy_blank_k2_nt,bigdata/kr2/results/Brachy_Blank.k2_report.txt 
#bracky_cells_k2_nt,bigdata/kr2/results/Brachy_cells.k2_report.txt 
#bracky_blank_cf_nt,bigdata/centrifuge/results/Brachy_Blank.krreport.txt 
bracky_cells_cf_nt,bigdata/centrifuge/results/Brachy_cells.krreport.txt 
#BC_SRSLY,bigdata/centrifuge/results/BC_SRSLY.krreport.txt 
)
odir=results/2025-11-05;mkdir -p $odir


#ktImportTaxonomy combined_kraken_report.txt -o combined_kraken_report.html
#python ../KrakenTools/combine_kreports.py  \
#  -r bigdata/centrifuge/results/Brachy_Blank.krreport.txt \
#     bigdata/centrifuge/results/Brachy_cells.krreport.txt \
#  -o combined_kraken_report.txt 
for i in ${input[@]};do
n=${i%,*}
f=${i#*,}
o=$odir/$n
#[ -s $o.html ] || \
echo "#!/bin/bash
dino kr2-filter $f 1 > $o.kreport 
python ../KrakenTools/kreport2krona.py -r $o.kreport -o $o.krona.txt --intermediate-ranks
ktImportText $o.krona.txt  -o $o.krona.html 
" #| sbatch  -o $o.out 
done
