## Discussion Points

-   ☒ : Quantify the proportion of reads mapped for Brachy\_Blank and
    Brachy\_cells in human and other species.

## Results

-   Data: bigdata/bwa\_scores/\*.tsv files on HPC
    -   example :

    <!-- -->

        id  seq Brachy_cells@allMis1    Brachy_cells@anoCar2    Brachy_cells@bearded_dragon Brachy_cells@brown_anole    Brachy_cells@crocodile  Brachy_cells@falcon Brachy_cells@galGal6    Brachy_cells@hg38   Brachy_cells@komodo_dragon  Brachy_cells@loxAfr3    Brachy_cells@mm10   Brachy_cells@ostrich
        LH00333:151:232G25LT3:2:2167:33774:18886    TGGCCCCGGAAGTCGTCGGC    0   0   0   0   0   0   0   0   0   0   16  0
        LH00333:151:232G25LT3:2:2176:26174:11745    AAATTTTGCTAAGGATATTTGCGTCAATTTTTATGAAGATTTTATCAAGAATATGGGTTGTAGTTTTCCATTATGATGTCTTTGTTGGAGTAATGCTGGCCT  0   102 0   0   0   0
        LH00333:151:232G25LT3:2:1172:50091:21945    CGACAGCGTCGTGACAGCTTC   0   0   0   0   0   0   0   0   0   0   17  17
-   Method :
    -   Bwa Alignment (aDNA fit) [code](../../02-bwa-rn.sh)
    -   Considered Species : allMis1 anoCar2 bearded\_dragon
        brown\_anole crocodile galGal6 hg38 komodo\_dragon loxAfr3 mm10
        ostrich
    -   Best Scoring [code](../../03-bwa-pl.sh)
    -   Score calculation:
        score = matches − mismatches − gap\_initiation

### Alignment Length Proportions

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th>Brachy Blank</th>
<th>Brachy Cells</th>
</tr>
</thead>
<tbody>
<tr>
<td><img src="figures/alignment_proportion_Brachy_Blank.png" /></td>
<td><img src="figures/alignment_proportion_Brachy_cells.png" /></td>
</tr>
</tbody>
</table>

### Contig/Scaffold Lengths

<figure>
<img src="figures/scaffold_dist.png" alt="png" />
<figcaption aria-hidden="true">png</figcaption>
</figure>
