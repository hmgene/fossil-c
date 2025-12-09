input=( 
#brachy_blank_k2_nt,bigdata/kr2/results/Brachy_Blank.k2_report.txt 
#bracky_cells_k2_nt,bigdata/kr2/results/Brachy_cells.k2_report.txt 
#bracky_blank_cf_nt,bigdata/centrifuge/results/Brachy_Blank.krreport.txt 
#bracky_cells_cf_nt,bigdata/centrifuge/results/Brachy_cells.krreport.txt 
#BC_SRSLY,bigdata/centrifuge/results/BC_SRSLY.krreport.txt 
bracky_csedi,bigdata/centrifuge/results/Brachy_c_sedi.krreport.txt
bracky_vessels,bigdata/centrifuge/results/Brachy_vessels.krreport.txt
bracky_vsedi,bigdata/centrifuge/results/Brachy_v_sedi.krreport.txt
trex_cells,bigdata/centrifuge/results/Trex_cells.krreport.txt
trex,csedi,bigdata/centrifuge/results/Trex_c_sedi.krreport.txt
trex_blank,bigdata/centrifuge/results/Trex_ExtrBlank.krreport.txt
trex_vessels,bigdata/centrifuge/results/Trex_vessels.krreport.txt
trex_vsedi,bigdata/centrifuge/results/Trex_v_sedi.krreport.txt

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
[ -s $o.html ] || \
echo "#!/bin/bash
#python ../KrakenTools/kreport2krona.py -r <( dino kr2-filter $f 1) -o $o.krona.txt 
python ../KrakenTools/kreport2krona.py -r $f -o $o.krona.txt 
ktImportText $o.krona.txt  -o $o.krona.html 
" | sbatch  -o $o.out 
done
