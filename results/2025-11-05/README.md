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

df <- read_tsv("summ.tsv")
```

    ## Rows: 7 Columns: 12
    ## ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: "\t"
    ## chr (12): rank, Brachy_c_sedi, Brachy_vessels, Trex_v_sedi, Trex_vessels, Tr...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
kable(df, format = "markdown")
```

| rank | Brachy_c_sedi | Brachy_vessels | Trex_v_sedi | Trex_vessels | Trex_cells | Brachy_cells | Trex_ExtrBlank | Brachy_v_sedi | Trex_c_sedi | Brachy_Blank | BC_SRSLY |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| top0 | unclassified ( 115364 ) | unclassified ( 203197 ) | unclassified ( 3947549 ) | unclassified ( 901446 ) | unclassified ( 558566 ) | unclassified ( 446627 ) | unclassified ( 1599906 ) | unclassified ( 130274 ) | unclassified ( 287081 ) | unclassified ( 314633 ) | unclassified ( 12688170 ) |
| top1 | root ( 42263832 ) | root ( 125850525 ) | root ( 9958837 ) | root ( 211226106 ) | root ( 171165670 ) | root ( 278325086 ) | root ( 15213911 ) | root ( 8295384 ) | root ( 46313890 ) | root ( 37454889 ) | root ( 33008119 ) |
| top2 | Komagataella ( 406482 ) | Homo ( 826359 ) | Cyprinus ( 344234 ) | Homo ( 1593836 ) | Komagataella ( 5258369 ) | Homo ( 1185431 ) | Komagataella ( 5036202 ) | Komagataella ( 130042 ) | Homo ( 1602551 ) | Pinus ( 6637267 ) | Cyprinus ( 1264443 ) |
| top3 | Homo ( 302991 ) | Mus ( 721813 ) | Homo ( 104514 ) | Mus ( 1520790 ) | Homo ( 4433855 ) | uncultured ( 1084609 ) | Homo ( 1327020 ) | Homo ( 110099 ) | Komagataella ( 787232 ) | Komagataella ( 4414018 ) | Homo ( 1130168 ) |
| top4 | Mus ( 268482 ) | uncultured ( 453065 ) | Mus ( 93676 ) | Bradyrhizobium ( 1272183 ) | Pinus ( 3808205 ) | Mus ( 1084601 ) | Cyprinus ( 700001 ) | Cyprinus ( 100252 ) | Alternaria ( 702888 ) | Homo ( 732525 ) | Mycobacterium ( 949054 ) |
| top5 | Cyprinus ( 198183 ) | Cyprinus ( 403706 ) | Komagataella ( 65203 ) | Pseudorhodoplanes ( 1051935 ) | Mus ( 2683007 ) | Spirometra ( 706143 ) | uncultured ( 129836 ) | uncultured ( 74139 ) | Mus ( 655032 ) | Cyprinus ( 516645 ) | Tarenaya ( 305647 ) |
| top6 | uncultured ( 174016 ) | Oryzias ( 399232 ) | Spirometra ( 49318 ) | Spirometra ( 945714 ) | Cyprinus ( 1376149 ) | Burkholderia ( 2590115 ) | Gossypium ( 120718 ) | Mus ( 73944 ) | Cyprinus ( 405530 ) | Mus ( 478875 ) | Mycobacterium ( 235898 ) |

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
