#!/bin/bash 
tail -n+2 bigdata/bwa_scores_+contig/Brachy_cells.tsv | cut -f 1 | uniq | wc -l > o
tail -n+2 bigdata/bwa_scores_+contig/Brachy_vessels.tsv | cut -f 1 | unique | wc -l >> o
