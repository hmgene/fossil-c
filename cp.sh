echo '#!/bin/bash
#SBATCH --time=300:00:00
ssh dtn2 "cp -r /mnt/vstor/SOM_GENE_BEG33/data/fossil-c /scratch/users/hxk728/"
ssh dtn2 "cp -r /scratch/users/hxk728/fossil-c /mnt/rds/Genetics02/Genetics/GryderLab/"
' | sbatch 
