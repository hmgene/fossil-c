## Discussion Points

-   ☒ : Make contigs out of Unclassified centrifuge results

## Methods

-   find unclassified reads
-   blast

## Results

### Centrifuge Results

<table style="width:100%;">
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th>Sample</th>
<th>Total Reads</th>
<th>Reads Merged</th>
<th>Merged Reads</th>
<th>Unclassified</th>
<th>Unclassified (&gt;20bp)</th>
</tr>
</thead>
<tbody>
<tr>
<td>Bracky_Blank</td>
<td>91592712</td>
<td>75539044</td>
<td>37769522</td>
<td>446627</td>
<td>179130</td>
</tr>
<tr>
<td>Bracky_cell</td>
<td>675698180</td>
<td>557543426</td>
<td>278771713</td>
<td>314633</td>
<td>205700</td>
</tr>
</tbody>
</table>

### Capedeam Results

-   Input: Unclassified (&gt;20bp)
-   Output:
    -   [Bracky\_Blank contigs](data/Brachy_Blank.unc.fa)
    -   [Bracky\_cells\_contigs](data/Brachy_cells.unc.fa)
    -   [Blast results](data/blast_res.csv)
