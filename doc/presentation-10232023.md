# Deep-time paleogenomics and the limits of DNA survival 
<img width="678" alt="image" src="https://github.com/hmgene/fossil-c/assets/23003112/5cf63c24-66a1-4466-8424-201fe33c9988">

pubmed id: [[37797036]]

## Introduction
>Pleistocene, an epoch of repeated environmental changes that shaped present-day biodiversity. 

>Middle Pleistocene, i.e., >126 ka, are still rare because postmortem processes lead to successive degradation of DNA molecules into increasingly small fragments, making DNA recovery more <ins>difficult</ins> with age. Early and Middle Pleistocene DNA has, however, been recovered from remains and sediments in high-latitude permafrost (10–14) and lower latitude caves (15, 16), suggesting that deep-time genomics is feasible in ideal <ins>preservation environments</ins>


![image](https://github.com/hmgene/fossil-c/assets/23003112/4d4d6494-ed61-4212-949a-1ea289d97385) 
> The temporal distribution of ancient DNA studies to date highlights gaps and opportunities for deep-time paleogenomics and sedimentary ancient DNA. Circles in orange are non-human animal paleogenomes, in blue are hominin paleogenomes, and in brown are sedimentary ancient DNA records. Most ancient DNA studies fall within the last 50 ka and the most recent glacial cycle. The climate curve is based on benthic δ18-Oxygen measurements (per mil, ‰; LR04 stack from (42). Sedimentary ancient DNA data are from the AncientMetagenomeDir (v23.06.0, 58) and von Eggers et al. (v1, https://doi.org/10.5281/zenodo.6847522), with metabarcoding records older than one million years excluded. Paleogenomes older than 100 ka are annotated with a silhouette of the study taxon, with the deep-time paleogenomes including a 130 ka steppe bison (36); 330 ka collared lemming (40); 360 ka cave bear (9); 430 ka cave bear and hominin (35, 59); 700 ka horse (8); and 700 ka, 1.1 Ma, and 1.2 Ma mammoths (10). Silhouettes are from PhyloPic (https://beta.phylopic.org/) and are in the public domain with credits to Zimices (mammoth, two bison) and Robert Bruce Horsfall (horse). LP: Late Pleistocene; IG: Interglacial; G: Glacial. [[37797036]]

## DNA persistence into deep time

>  The primary chemical mechanism of DNA fragmentation is hydrolytic depurination. This process removes adenine or guanine bases, creating abasic sites that can be cleaved by β elimination (19; Fig. 2C), and leading to purine overrepresentation adjacent to strand breaks (20; Fig. 2E) and interior gaps (21).

![image](https://github.com/hmgene/fossil-c/assets/23003112/7d1c9492-d96d-4f37-886d-ae1c4e16fc15)

>Hydrolytic deamination, another common form of chemical damage, converts cytosine to uracil and is observed as thymine in sequencing data, or “C-to-T transitions” (Fig. 2C). Deamination occurs primarily near strand ends and in single-stranded DNA (17, 21, 22; Fig. 2E)
 
![image](https://github.com/hmgene/fossil-c/assets/23003112/9b626169-aa5d-4b41-90d2-bf081993baab)
> In 1993, Lindahl estimated that hydrolytic depurination would lead to complete degradation of DNA molecules within several tens of thousands of years (17). However, the maximum age of recoverable and useful DNA molecules—those that are long enough to retain information—remains <ins>uncertain</ins>.
![image](https://github.com/hmgene/fossil-c/assets/23003112/d86344c8-7419-4f26-9afd-e9cd3dc2effe)
> In nuclear DNA, strands are cleaved in labile regions of histone-DNA complexes, resulting in a ~10-base periodicity in the distribution of the lengths of recovered molecules (18).
> The primary chemical mechanism of DNA fragmentation is hydrolytic depurination. This process removes adenine or guanine bases, creating abasic sites that can be cleaved by β elimination (19) (Fig. 2C), and leading to purine overrepresentation adjacent to strand breaks (20) (Fig. 2E) and interior gaps (21). 
> Hydrolytic deamination, another common form of chemical damage, converts cytosine to uracil and is observed as thymine in sequencing data, or “C-to-T transitions” (Fig. 2C).

### Recovery of increasingly old and damaged DNA
- single-strand approaches
<details><summary>[28119419]</summary>  

![image](https://github.com/hmgene/fossil-c/assets/23003112/da3e0b2d-807a-42bb-9821-c9fd519ed6d7)
[28119419](https://pubmed.ncbi.nlm.nih.gov/28119419/)

</details>

- treated with uracil DNA glycosylase and endonuclease VIII to reduce deamination damage by removing uracil bases
- Bioinformatic approaches mitigate these challenges by directly modeling DNA damage and/or bias as part of genotyping (28) or considering only substitutions that are not affected by cytosine deamination.

<details><summary>submodel</summary>

![image](https://github.com/hmgene/fossil-c/assets/23003112/d781c621-786e-4fc8-bfae-912fa8a57f6e)
[PMC6289138](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6289138/#sup1)

</details>

> The short nature of deep-time DNA molecules makes them prone to spurious alignment and reference bias (27), complicating genome assembly and analysis. 

## Research opportunities arising from deep-time DNA

### Speciation and evolution
![image](https://github.com/hmgene/fossil-c/assets/23003112/86909a28-7bed-477f-a6b4-8faaa0038bf8)
>**Deep-time paleogenomes provided new understanding of the evolutionary history of mammoths.** Paleontological hypotheses assumed that the M. columbi lineage evolved after early divergence from M. primigenius (A), however, isolation of a deep-time paleogenome from the Krestova mammoth (blue circle) revealed that M. columbi emerged more recently and following admixture with the Krestova mammoth lineage (B).

### The impact of glacial cycles on biodiversity
### Inference of ancient ecosystems
- it possible to reconstruct entire deep-time ecological communities.
- sedimentary ancient DNA 
- hybridization capture on deep-time sedimentary DNA
### Future research to enable deep-time DNA
- Kjaer et al (11) found that DNA adsorbed preferentially to clay mineral surfaces compared to non-clay surfaces, and in particular to the clay mineral smectite, which can <ins>bind 200 times more DNA than quartz</ins> and is a common mineral in terrestrial samples. Their best performing extraction protocol recovered 40% of DNA bound to quartz and only 5% of DNA bound to smectite.
- Massilani et al (47), for example, showed DNA preserved in cave sediment is concentrated in <ins>micro-scale particles, especially fragments of bone</ins> and feces preserved within the substrate.
- 100 picograms of DNA into libraries using the Santa Cruz method (25), library preparation has been shown to typically convert only around 10–50% of extracted DNA (21)
- challenges to ancient DNA authentication and identification as well as to reference-guided genome assembly.
  - multi-species variation graphs that incorporate variants from several genomes (52),
  - reference-based taxonomic assignment is always limited to sequences deposited in public databases, the ongoing population of these databases will continue to improve robust identification of DNA recovered from Early and Middle Pleistocene remains and sediments.
- luminescence and electron spin resonance [ESR]) and amino acid (AA) geochronology [36252044/](https://pubmed.ncbi.nlm.nih.gov/36252044/) - half-life of carbon-14 < ~50 ka. 
- evolutoin model with generation length and molecular history
<details>
<summary>Algorithms </summary>
- FASTME: https://academic.oup.com/mbe/article/32/10/2798/1212138

![image](https://github.com/hmgene/fossil-c/assets/23003112/f30038f5-a6de-4ae0-807c-0bc5336f433d)
https://ginolhac.github.io/mapDamage/

</details>

<details>
<summary>Sequence data processing and mapping </summary>
We combined our obtained sequence data with that from previously published40 elephantid
genomes that include all extant and three extinct species (Table S2). For the five samples
>sequenced here, we trimmed adapters and merged paired-end reads using SeqPrep 1.141, initially
retaining reads either ≥25 bp (Krestovka, Adycha, Chukochya) or ≥30 bp (Scotland, Kanchalan),
and with a minor modification in the source code that allowed us to choose the best base quality
score in the merged region instead of aggregating the scores42. Three of the ancient genomes in
the dataset had been treated with the afu UDG enzyme (the straight-tusked elephant and the
Scotland and Kanchalan mammoths, Table S2), which leaves post-mortem DNA damage at the
DNA fragment termini. Therefore, for these samples, we removed the first and last two base pairs
from all reads before mapping in order to minimize erroneous bases. Next, we mapped the
merged reads to a composite reference consisting of the African savannah elephant nuclear
genome (LoxAfr4), woolly mammoth mitogenome (Krause mammoth, DQ188829), and the
human genome (hg19) using BWA aln v0.7.8 with deactivated seeding (-l 16,500), allowing for
more substitutions (-n 0.01) and up to two gaps (-o 2)43,44. We used Samtools v0.1.1945 to process
the alignment and filter reads with mapping quality below 30 and we used BEDtools v.2.27.146 to
split the elephant- and mammoth-mapped regions of autosomes, chromosome X and
mitogenomes. Next, we removed PCR duplicates from the alignments using a python script
(github.com/pontussk/samremovedup) that takes into account both start and end positions of the
reads following Palkopoulou et al.42. Finally, we removed all reads below 35 base pairs from the
BAM-files using samtools to filter out spurious mappings (see Supplementary Section 4).
[PMC7116897](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7116897/)

</details>

<details>
<summary>Ancient DNA authenticity and quality assessment</summary>

All ancient genomes in this study were UDG treated to reduce biased inferences resulting from
post-mortem DNA damage. Given the extreme age of the most ancient samples (Krestovka,
Adycha, Chukochya), we extensively assessed the authenticity and quality of our mapped
sequence data. First, only reads that mapped uniquely to non-repetitive regions of the LoxAfr4
reference and had a mapping quality ≧30 were retained. To do this, we included the human
genome reference (hg19) in our composite reference as a mapping decoy to ensure that reads
mapping equally well to conserved genomic regions between LoxAfr4 and hg19 were removed,
and thus reducing possible biases caused by human contaminating reads47. We next used
mapDamage2.0.648 to obtain read length distributions for all ancient samples. We observed an
uptick in the count of 25-30 bp mapped reads for the two low-coverage samples (Adycha,
Krestovka; Extended Data Fig. 3), which is characteristic of spuriously aligned ultrashort reads49.
To determine sample-specific minimum read length cutoffs, we employed a method to assess the
rate of spurious mappings for all reads between 20-35 bp and at 5 bp intervals between 35-50 bp
(Fig. S3). In each genome, we sampled all alleles with mapping quality ≥30 and base quality ≥30
13
at each genomic site and counted how many of these did not match the LoxAfr4 reference. The
underlying reasoning is that the rate of allele mismatches should be constant as a function of read
length if no spurious alignments are present. It is challenging to accurately map ultrashort reads
(e.g. <35 bp)50, but we expect spurious alignments from short reads (both of endogenous and
non-endogenous origin) to have a different rate of mismatches to the reference than correctlymapped
endogenous reads. This allowed us to identify a sample-specific minimum read length
cutoff above which we consider reads to be correctly mapped and endogenous (Fig. S3, Table
S3). For consistency, we applied the longest sample-specific cutoff (≥35 bp, Krestovka; Fig. S3;
Table S3) to all samples in downstream analysis using samtools and awk (samtools view -h
filename.bam | 'length($10) > 34 || $1 ~ /^@/' | samtools view -bS - > 35bp.filename.bam). The
scripts used to run this analysis are available at (github.com/stefaniehartmann/readLengthCutoff).
We present ancient DNA quality statistics for each of the ancient samples in Table S3, for both
the sample-specific and 35 bp minimum read length datasets. Based on reads aligned to the
LoxAfr4 autosomes, we calculated the (1) count of reads aligned, using the flagstat command in
SAMtools v.0.1.1945; (2) average genomic coverage, using the mean of values derived from
samtools depth -a; (3) proportion of the genome uncovered, using the count of sites with zero
derived from samtools depth -a divided by the total length of the autosomes; (4) average read
length, using samtools view -F 4 and bash commands; and (5) deamination frequency at the
terminal nucleotide positions, based on the proportion of C>T at the first position in the forward
direction as estimated by mapDamage. As all ancient samples were UDG treated, overall cytosine
deamination frequencies calculated by mapDamage were low (Table S3). We therefore
additionally examined cytosine deamination profiles at CpG sites, which are unaffected by UDG
treatment51, using the platypus option in PMDtools (github.com/pontussk/PMDtools)52. The three
samples processed with afu UDG enzyme during single-strand DNA library preparation (Scotland,
Kanchalan, and the straight-tusked elephant) had elevated C>T misincorporations at the terminal
positions, as compared to the other ancient samples. For these three samples, we therefore
trimmed the first and last two bases from the merged reads, and then remapped and filtered the
trimmed reads as outlined above. We show that the average read lengths for the most ancient
samples (Krestovka, Adycha, Chukochya) are 42-49 bp, after excluding reads <35 bp (Extended
Data Fig. 3; Table S3). These are comparable to other younger specimens, but we note that these
younger specimens were either sampled from warmer localities with less optimal DNA
preservation (Columbian mammoth, Wyoming woolly mammoth) or processed using laboratory
methods (i.e. single-strand DNA library preparation) that generate, and are biased toward the
recovery of, ultrashort fragments (Scotland, Kanchalan). However, the Krestovka, Adycha, and
Chukochya average read lengths are far shorter than those generated from the Oimyakon (59 bp)
and Wrangel (72 bp) mammoths, which are comparable in terms of preservational context
(permafrozen) and laboratory processing. The cytosine deamination frequencies at CpG sites are
up to three times higher in the Krestovka, Adycha, and Chukochya data sets, as compared to
other younger mammoths (Extended Data Fig. 4), which is consistent with their old age.
[PMC7116897](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7116897/)

</details>



[[37797036]] Deep-time paleogenomics and the limits of DNA survival

[37797036]: https://pubmed.ncbi.nlm.nih.gov/37797036/

