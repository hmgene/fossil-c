## Gene Feature Annotation on the De Novo Assembly

### Method
- Annotated gene features on Bracky_cells contigs (>10 kb) using AUGUSTUS.
- Converted the resulting GFF files to BED12 format, modifying the chromosome field to “chr1” to accommodate genes accumulated across different contigs.
- Visualized the annotated genes in a genome browser.


### Transcript profiles (gene length, exons)
| Bracky Blank | Bracky Cells |
| ------- | --------|
| ![png](figures/contour_bracky_blank.png) | ![png](figures/contour_bracky_cells.png) |

### Semi-genome gene shapes (genes with a least 3 exons)

<img width="917" height="436" alt="image" src="https://github.com/user-attachments/assets/b5517bba-26ba-4f06-9b03-9cefa2f83b6e" />

