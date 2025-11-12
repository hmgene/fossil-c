input=( 
brachy_blank_k2_nt,bigdata/kr2/results/Brachy_Blank.k2_report.txt 
bracky_cells_k2_nt,bigdata/kr2/results/Brachy_cells.k2_report.txt 
bracky_blank_cf_nt,bigdata/centrifuge/results/Brachy_Blank.krreport.txt 
bracky_cells_cf_nt,bigdata/centrifuge/results/Brachy_cells.krreport.txt 
bigdata/centrifuge/results/BC_SRSLY.krreport.txt 
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
#python ../KrakenTools/kreport2krona.py -r $f -o $o.krona.txt
python ../KrakenTools/filter_bracken_kreport.py -r $o.krona.txt -t 0.01 -o $o.krona.flt.txt 
ktImportText $o.krona.flt.txt  -o $o.krona.html 
" | sbatch  -o $o.out 
done
