# fossil-c Bracky & T-rex
## Synapsis
- We show that combining our different mapping and filtering approaches can increase the number of high-quality endogenous hits recovered by up to X%.

## Methods

1. trim FASTQ files using [fastp](https://github.com/OpenGene/fastp) with various options (Q: quality, L: length, g: G-tail, x: poly-x, y: low-complexity )

| input | output | program |
| - | - | - |
| *.fastq.gz | fq1/[QLxy]+/*.fastq.gz | 01-trim-fastq.sh |

2. merge FASTQ files

| input | output | program |
| - | - | - |
| fq1/*/bra_*.fastq.gz | fq2/*/bra_*.fastq.gz | 02-merge-fastq.sh |


2. Mapping : reads were mapped to six genomes (UCSC) using the bwa tool [bwa](https://bio-bwa.sourceforge.net/)

 - Deal with reference bias, artefacts and short DNA read fragmentization [PMID:33834210]( https://pubmed.ncbi.nlm.nih.gov/33834210/ )

| input | output | program |
| - | - | - |
| fq[12]/Qxyz/*.fastq.gz | bw/*.fastq.gz | 03-bwa.sh |


## Tools
- TOGA,  inferring orthologs and classifying genes as intact or lost https://github.com/hillerlab/TOGA
- w2rap contig, https://www.biorxiv.org/content/10.1101/110999v1
- D-statisitc, https://www.bodkan.net/admixr/articles/tutorial.html
- https://repeatbrowser.ucsc.edu/
- pathFinder : https://academic.oup.com/mbe/article/39/2/msac017/6516020
- MAPLE (large scale phylogeny) : https://onlinelibrary.wiley.com/doi/10.1111/jse.12535 
- 

### 
Whole-genome phylogeny of mammals: Evolutionary information in genic and nongenic regions
- “feature frequency profile” (FFP) method of alignment-free comparison.  
- non-genic portion of genomes contain evolutionary information 

Determination of k-mer density in a DNA sequence and subsequent cluster formation algorithm based on the application of electronic filter
- q-gram => phylogeny


### mecay Models
- schmutzi : https://github.com/grenaud/schmutzi
- https://academic.oup.com/bioinformatics/article/38/15/3768/6607584

- AuthentiCT : https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02123-y

- http://ginolhac.github.io/mapDamage/

```
Using container
A container by quay.io is available if you are using docker
Usage as below:

docker pull quay.io/biocontainers/mapdamage2:2.2.0--pyr36_1
[...]
docker run -ti quay.io/biocontainers/mapdamage2:2.2.0--pyr36_1 /bin/bash
bash-4.2# mapDamage --check-R-packages
All R packages are present
```
Improving ancient DNA read mapping against modern reference genomes
https://bmcgenomics.biomedcentral.com/articles/10.1186/1471-2164-13-178
- trimming and indel-panelty effects on contaminated but useful reads
- post-morterm DNA damage is inferred from nucleotide misincorporation patterns [mapDamage]
  - mainly result from post-mortem deamination of cytosine residues into uracil residues, and for Illumina reads consist of an increase of C → T misincorporations at the 5’-ends of sequencing reads paralleled by an increase in G → A misincorporations at 3’-ends[10, 19, 21]; for Helicos tSMS reads, the deamination of cytosine residues results in an increase in G → A mismatches at 5’-ends of sequencing reads[15].
- Importantly, nucleotide misincorporations related to cytosine deamination were found to dominate mismatch patterns over the full length of sequencing reads, confirming that the new hits identified consisted of reads of ancient origin, as cytosine deamination has been shown to be the most prevalent form of post-mortem damage[19, 22–25]. 
- Increasing our tolerance for higher edit distances might help with recovering this fraction, at the risk of accepting a larger proportion of reads of exogenous origin.

### trimming
- https://github.com/grenaud/leeHom https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4191382/ 

### mapping
- BWA-aln is better https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.8297
- BWA-mem is fine https://academic.oup.com/bib/article/22/5/bbab076/6217726
  - ‘deamSim’ function from gargammel [22] 
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
Soft sheets of fibrillar bone from a fossil of the supraorbital horn of the dinosaur Triceratops horridus

Three-dimensional genome architecture persists in a 52,000-year-old
woolly mammoth skin sample
https://www.biorxiv.org/content/10.1101/2023.06.30.547175v1.full.pdf
mammoth, hi-C, 3D genome

Integrating gene annotation with orthology inference at scale
https://github.com/hillerlab/TOGA
https://genome.senckenberg.de/
https://github.com/hillerlab/make_lastz_chains

shaking a tree of life including dinosaurs in yeast 
https://www.glbrc.org/news/chris-todd-hittinger-motivated-missing-links-yeast-evolution

Toward a genome sequence for every animal: Where are we now?
https://www.pnas.org/doi/10.1073/pnas.2109019118

Elephant shark genome provides unique insights into gnathostome evolution
https://www.nature.com/articles/nature12826

Ancient DNA analysis https://www.nature.com/articles/s43586-020-00011-0
- Breaking down individual error rates per nucleotide substitution type (for example, C to T, G to A, C to A and G to T) generally reveals a pervasive excess of transitions (C to T, G to A and their reciprocal changes) owing to post-mortem cytosine deamination7.

Placing Ancient DNA Sequences into Reference Phylogenies 
- pathPhynder


Ancient DNA https://www.nature.com/articles/35072071#Glos9
- contamination with modern or recent DNA, Human remains 

Cretaceous ornithurine supports a neognathous crown bird ancestor

Three crocodilian genomes reveal ancestral patterns of evolution among archosaurs
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4386873/

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

Codon usage bias, https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8613526/

