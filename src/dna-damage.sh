# samtools view bigdata2/SRSLY_BR_O_S1/SRSLY_BR_O_S1.R1.bwa@allMis1.bam |head -n10 | fo sam2bed  - |bedtools getfasta -fi ../../db/bwa/allMis1/allMis1.fa -bed stdin -name -bedOut

