# brachy
## Tools
### Centrifuge
good explanation https://macadology.com/guide/Centrifuge/


## Visualization
Show mappability of Bracky samples using ncbi TAXONOMY

1. go to ncbi to make related tree
https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=8496

2. visualize tree in R
```
library(ggtree)
t=read.tree('~/Downloads/phyliptree.phy'')
ggree(t)

```

ggtree usage:
- https://guangchuangyu.github.io/ggtree-book/chapter-ggtree.html

## Data
Download microorganism input fastqs
```
srr=(
SRR10173838 #Microbiome in dinosaur bone
SRR10173105 #Microbiome in adjacent sediment
)

module load sratoolkit/3.0.0
for f in ${srr[@]};do
        cat<<-eof | sbatch
        #!/bin/bash -l
        fastq-dump --split-files --gzip $f
        eof
done
```


## Articles
Cretaceous dinosaur bone contains recent organic material and provides an environment conducive to microbial communities

NAR2017, A new model for ancient DNA decay based on paleogenomic meta-analysis https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5499742/
- ancient DNA decay models,  
- code: https://datadryad.org/stash/dataset/doi:10.5061%2Fdryad.5r10j
- data: https://www.ebi.ac.uk/ena/browser/view/ERR844243?show=reads

EM2020, Genome-centric resolution of novel microbial lineages in an excavated Centrosaurus dinosaur fossil bone from the Late Cretaceous of North America
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8067395/
- SRR10173838 #Microbiome in dinosaur bone, SRR10173105 #Microbiome in adjacent sediment

Sci2009Mary, Mary H Schweitzer, Biomolecular characterization and protein sequences of the Campanian hadrosaur B. canadensis, 
- brachy collagen, https://pubmed.ncbi.nlm.nih.gov/19407199/
- endogenous proteinaceous material is preserved in bone fragments and soft tissues from an 80-million-year-old Campanian hadrosaur, Brachylophosaurus canadensis [Museum of the Rockies (MOR) 2598]
- complement earlier results from Tyrannosaurus rex (MOR 1125) and confirm that molecular preservation in Cretaceous dinosaurs is not a unique event

Centrifuge, meta analysis for microorganism https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5131823/

Human ancient DNA, https://www.ebi.ac.uk/ena/browser/view/ERR844243?show=reads
