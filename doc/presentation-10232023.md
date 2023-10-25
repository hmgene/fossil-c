Deep-time paleogenomics and the limits of DNA survival [[37797036]]
>Middle Pleistocene, i.e., >126 ka, are still rare because postmortem processes lead to successive degradation of DNA molecules into increasingly small fragments, making DNA recovery more difficult with age. Early and Middle Pleistocene DNA has, however, been recovered from remains and sediments in high-latitude permafrost (10–14) and lower latitude caves (15, 16), suggesting that deep-time genomics is feasible in ideal preservation environments


![image](https://github.com/hmgene/fossil-c/assets/23003112/4d4d6494-ed61-4212-949a-1ea289d97385) 
> The temporal distribution of ancient DNA studies to date highlights gaps and opportunities for deep-time paleogenomics and sedimentary ancient DNA. Circles in orange are non-human animal paleogenomes, in blue are hominin paleogenomes, and in brown are sedimentary ancient DNA records. Most ancient DNA studies fall within the last 50 ka and the most recent glacial cycle. The climate curve is based on benthic δ18-Oxygen measurements (per mil, ‰; LR04 stack from (42). Sedimentary ancient DNA data are from the AncientMetagenomeDir (v23.06.0, 58) and von Eggers et al. (v1, https://doi.org/10.5281/zenodo.6847522), with metabarcoding records older than one million years excluded. Paleogenomes older than 100 ka are annotated with a silhouette of the study taxon, with the deep-time paleogenomes including a 130 ka steppe bison (36); 330 ka collared lemming (40); 360 ka cave bear (9); 430 ka cave bear and hominin (35, 59); 700 ka horse (8); and 700 ka, 1.1 Ma, and 1.2 Ma mammoths (10). Silhouettes are from PhyloPic (https://beta.phylopic.org/) and are in the public domain with credits to Zimices (mammoth, two bison) and Robert Bruce Horsfall (horse). LP: Late Pleistocene; IG: Interglacial; G: Glacial. [[37797036]]


![image](https://github.com/hmgene/fossil-c/assets/23003112/d86344c8-7419-4f26-9afd-e9cd3dc2effe)
figure from [[37797036]]
>  The primary chemical mechanism of DNA fragmentation is hydrolytic depurination. This process removes adenine or guanine bases, creating abasic sites that can be cleaved by β elimination (19; Fig. 2C), and leading to purine overrepresentation adjacent to strand breaks (20; Fig. 2E) and interior gaps (21).
 
![image](https://github.com/hmgene/fossil-c/assets/23003112/9b626169-aa5d-4b41-90d2-bf081993baab)
![image](https://github.com/hmgene/fossil-c/assets/23003112/7d1c9492-d96d-4f37-886d-ae1c4e16fc15)


>Hydrolytic deamination, another common form of chemical damage, converts cytosine to uracil and is observed as thymine in sequencing data, or “C-to-T transitions” (Fig. 2C). Deamination occurs primarily near strand ends and in single-stranded DNA (17, 21, 22; Fig. 2E)

![image](https://github.com/hmgene/fossil-c/assets/23003112/d781c621-786e-4fc8-bfae-912fa8a57f6e)
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6289138/#sup1

![image](https://github.com/hmgene/fossil-c/assets/23003112/86909a28-7bed-477f-a6b4-8faaa0038bf8)
>**Deep-time paleogenomes provided new understanding of the evolutionary history of mammoths.** Paleontological hypotheses assumed that the M. columbi lineage evolved after early divergence from M. primigenius (A), however, isolation of a deep-time paleogenome from the Krestova mammoth (blue circle) revealed that M. columbi emerged more recently and following admixture with the Krestova mammoth lineage (B).

<details>
<summary>Algorithms </summary>
- FASTME: https://academic.oup.com/mbe/article/32/10/2798/1212138
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



[[37797036]] Deep-time paleogenomics and the limits of DNA survival

[37797036]: https://pubmed.ncbi.nlm.nih.gov/37797036/

