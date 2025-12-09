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

    ## Rows: 11 Columns: 8
    ## ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: "\t"
    ## chr (8): sample, top1, top2, top3, top4, top5, top6, top7
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
kable(df, format = "markdown")
```

| sample | top1 | top2 | top3 | top4 | top5 | top6 | top7 |
|:---|:---|:---|:---|:---|:---|:---|:---|
| Trex_v_sedi | root ( 9958837 ) | unclassified ( 3947549 ) | Cyprinus ( 344234 ) | Homo ( 104514 ) | Mus ( 93676 ) | Komagataella ( 65203 ) | Spirometra ( 49318 ) |
| Brachy_c_sedi | root ( 42263832 ) | Komagataella ( 406482 ) | Homo ( 302991 ) | Mus ( 268482 ) | Cyprinus ( 198183 ) | uncultured ( 174016 ) | unclassified ( 115364 ) |
| Trex_vessels | root ( 211226106 ) | Homo ( 1593836 ) | Mus ( 1520790 ) | Bradyrhizobium ( 1272183 ) | Pseudorhodoplanes ( 1051935 ) | Spirometra ( 945714 ) | unclassified ( 901446 ) |
| BC_SRSLY | root ( 33008119 ) | unclassified ( 12688170 ) | Cyprinus ( 1264443 ) | Homo ( 1130168 ) | Mycobacterium ( 949054 ) | Tarenaya ( 305647 ) | Mycobacterium ( 235898 ) |
| Trex_cells | root ( 171165670 ) | Komagataella ( 5258369 ) | Homo ( 4433855 ) | Pinus ( 3808205 ) | Mus ( 2683007 ) | Cyprinus ( 1376149 ) | unclassified ( 558566 ) |
| Brachy_cells | root ( 278325086 ) | Burkholderia ( 2590115 ) | Homo ( 1185431 ) | uncultured ( 1084609 ) | Mus ( 1084601 ) | Spirometra ( 706143 ) | unclassified ( 446627 ) |
| Trex_ExtrBlank | root ( 15213911 ) | Komagataella ( 5036202 ) | unclassified ( 1599906 ) | Homo ( 1327020 ) | Cyprinus ( 700001 ) | uncultured ( 129836 ) | Gossypium ( 120718 ) |
| Trex_c_sedi | root ( 46313890 ) | Homo ( 1602551 ) | Komagataella ( 787232 ) | Alternaria ( 702888 ) | Mus ( 655032 ) | Cyprinus ( 405530 ) | unclassified ( 287081 ) |
| Brachy_vessels | root ( 125850525 ) | Homo ( 826359 ) | Mus ( 721813 ) | uncultured ( 453065 ) | Cyprinus ( 403706 ) | Oryzias ( 399232 ) | unclassified ( 203197 ) |
| Brachy_Blank | root ( 37454889 ) | Pinus ( 6637267 ) | Komagataella ( 4414018 ) | Homo ( 732525 ) | Cyprinus ( 516645 ) | Mus ( 478875 ) | unclassified ( 314633 ) |
| Brachy_v_sedi | root ( 8295384 ) | unclassified ( 130274 ) | Komagataella ( 130042 ) | Homo ( 110099 ) | Cyprinus ( 100252 ) | uncultured ( 74139 ) | Mus ( 73944 ) |

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
