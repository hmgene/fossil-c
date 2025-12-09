## Brachy Krona Visualization Dashboard (2025-11-05)

### Summary

We applied both k-mer–based (Kraken2) and alignment-based (Centrifuge)
approaches to assess the authenticity of putative dinosaur DNA. The
purpose of using additional Centrifuge is to allow partial and
mismatched alignments, enabling examination of sequences that remain
unclassified by exact k-mer matching. K-mer–based detection (Kraken2)
captures unmutated fragments, while alignment-based analysis
(Centrifuge) identifies reads related to modern or ancestral taxa
through partial homology. Notably, unclassified reads from blank
controls show ambiguous partial matches across multiple species, whereas
reads from cellular samples span a broader range of unknown or poorly
annotated organisms.

### Discussion Points

- [x] Generate Krona plots **without pruning** (previously, 1% fraction
  was used).  
- [x] Include **earlier dataset**: Brachy Cell SRSLY added.  
- [ ] Decompile **partial / multi-species data** (SAM output attempted
  but not working)
  - [ ] Extract reads under Archelosauria Taxanomy

### Input

LeeHom Trimmed, Merged FastQ
[link](https://github.com/hmgene/fossil-c/tree/main/results/2025-10-08-read-adapter-positions)

### K-mer w/ Kraken2 @ nt db

| File | Method | Link |
|----|----|----|
| Bracky_Blank | Kraken2 | ![svg](figures/snapshot-kr2-brach-blank.svg) [View](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/brachy_blank_k2_nt.krona.html) |
| bracky_cells | Kraken2 | ![svg](figures/snapshot-kr2-brach-cells.svg) [View](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_cells_k2_nt.krona.html) |

### (Partial \> 16 bp) Alignment w/ Centrifuge @ nt db

K-mer (Kraken2) identifies mutation-free fragments, while
alignment-based (Centrifuge) analysis reveals ancestral and modern
species sequences, with cells mapping to more unknown species than blank
samples.

``` r
library(readr)
library(knitr)
library(dplyr)
df <- read_tsv("summ.tsv") %>%
  mutate(across(everything(), ~ gsub("\\(", "<br>(", as.character(.x))))
kable(df, format = "markdown")
```

| rank | BC_SRSLY | Brachy_Blank | Brachy_c_sedi | Brachy_cells | Brachy_v_sedi | Brachy_vessels | Trex_ExtrBlank | Trex_c_sedi | Trex_cells | Trex_v_sedi | Trex_vessels |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| top0 | unclassified <br>(12688170) | unclassified <br>(314633) | unclassified <br>(115364) | unclassified <br>(446627) | unclassified <br>(130274) | unclassified <br>(203197) | unclassified <br>(1599906) | unclassified <br>(287081) | unclassified <br>(558566) | unclassified <br>(3947549) | unclassified <br>(901446) |
| top1 | root <br>(33008119) | root <br>(37454889) | root <br>(42263832) | root <br>(278325086) | root <br>(8295384) | root <br>(125850525) | root <br>(15213911) | root <br>(46313890) | root <br>(171165670) | root <br>(9958837) | root <br>(211226106) |
| top2 | Cyprinus <br>(1264443) | Pinus <br>(6637267) | Komagataella <br>(406482) | Homo <br>(1185431) | Komagataella <br>(130042) | Homo <br>(826359) | Komagataella <br>(5036202) | Homo <br>(1602551) | Komagataella <br>(5258369) | Cyprinus <br>(344234) | Homo <br>(1593836) |
| top3 | Homo <br>(1130168) | Komagataella <br>(4414018) | Homo <br>(302991) | uncultured <br>(1084609) | Homo <br>(110099) | Mus <br>(721813) | Homo <br>(1327020) | Komagataella <br>(787232) | Homo <br>(4433855) | Homo <br>(104514) | Mus <br>(1520790) |
| top4 | Mycobacterium <br>(949054) | Homo <br>(732525) | Mus <br>(268482) | Mus <br>(1084601) | Cyprinus <br>(100252) | uncultured <br>(453065) | Cyprinus <br>(700001) | Alternaria <br>(702888) | Pinus <br>(3808205) | Mus <br>(93676) | Bradyrhizobium <br>(1272183) |
| top5 | Tarenaya <br>(305647) | Cyprinus <br>(516645) | Cyprinus <br>(198183) | Spirometra <br>(706143) | uncultured <br>(74139) | Cyprinus <br>(403706) | uncultured <br>(129836) | Mus <br>(655032) | Mus <br>(2683007) | Komagataella <br>(65203) | Pseudorhodoplanes <br>(1051935) |
| top6 | Mycobacterium <br>(235898) | Mus <br>(478875) | uncultured <br>(174016) | Burkholderia <br>(2590115) | Mus <br>(73944) | Oryzias <br>(399232) | Gossypium <br>(120718) | Cyprinus <br>(405530) | Cyprinus <br>(1376149) | Spirometra <br>(49318) | Spirometra <br>(945714) |

details:

[BC_SRSLY.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/BC_SRSLY.krona.html)  
[brachy_blank_k2_nt.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/brachy_blank_k2_nt.krona.html)  
[bracky_blank_cf_nt.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_blank_cf_nt.krona.html)  
[bracky_cells_cf_nt.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_cells_cf_nt.krona.html)  
[bracky_cells_k2_nt.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_cells_k2_nt.krona.html)  
[bracky_csedi.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_csedi.krona.html)  
[bracky_vessels.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_vessels.krona.html)  
[bracky_vsedi.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/bracky_vsedi.krona.html)  
[trex_blank.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/trex_blank.krona.html)  
[trex_cells.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/trex_cells.krona.html)  
[trex_vessels.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/trex_vessels.krona.html)  
[trex_vsedi.krona.html](https://raw.githack.com/hmgene/fossil-c/main/results/2025-11-05/trex_vsedi.krona.html)
