## Discussion Points

<details><summary expand></summary>
### (1) Coding Potential of Contigs
- Examine assembled contigs for **protein-coding potential**.
- Initial analyses have been performed (Hyunmin), but results have not yet been presented.
- Consider ab initio gene prediction and homology-based annotation approaches.

---

### (2) Conserved Vertebrate Genes
- Screen contigs for **genes conserved across vertebrates**, such as:
  - Histone genes (H2A, H2B, H3, H4)
  - Ribosomal proteins
  - Core housekeeping genes
- Presence of conserved loci would support biological authenticity.

---

### (3) DNA Damage Detection (aDNA Authentication)
- Classical aDNA damage detection relies on:
  - C→T substitutions at 5′ ends
  - G→A substitutions at 3′ ends
- Typically requires a **reference genome**.

**Key Question:**  
Can a **de novo scaffold** function as a reference for damage profiling?

- If most authentic base pairs are located toward the **middle of DNA inserts**, end-specific damage may still be detectable.
- Requires read-to-contig mapping and orientation-aware analysis.
- Scaffold errors and assembly artifacts must be considered.

---

### (4) SINE/LINE Divergence (Reptiles vs Birds)
- Revisit known divergence patterns of transposable elements.
- Develop a bioinformatic strategy to:
  - Identify repeat families in contigs
  - Compare divergence from consensus sequences
  - Assess lineage-specific repeat signatures
- Evaluate whether TE patterns are consistent with reptilian vs avian origin.

---

### (5) Scaffold Target Specificity
- Test whether the **T-rex cell scaffold** is the primary mapping target of T-Rex blood vessel DNA reads.
- Compare with observations from Brachy analysis.
- Assess enrichment, coverage distribution, and specificity.

---

### (6) Centrifuge Classification Review
- Critically evaluate:
  - Minimum bp match thresholds
  - Alignment confidence
  - Lowest Common Ancestor (LCA) assignments
- Investigate why many reads are classified to a **clade** but not to a **species**:
  - Short read length?
  - Conserved genomic regions?
  - Database limitations?

---

### (7) Blank & Sediment Controls
- Confirm that blanks and sediment samples predominantly map to:
  - *Komagataella phaffii*
    - Common recombinant protein production yeast
    - Likely source of kit-derived contamination (e.g., polymerases)
- Ensure controls do not show unexpected vertebrate signal.
- Validate contamination profile consistency across samples.

</details>

Ancient DNA Reads
        ↓
De novo Assembly
        ↓
Contigs / Scaffolds
        ↓
----------------------------------------
| 1. Structural Annotation             |
|    → AUGUSTUS gene prediction        |
----------------------------------------
        ↓
----------------------------------------
| 2. Sequence Representation Learning  |
|    → Train / Fine-tune Evo2 model    |
----------------------------------------
        ↓
----------------------------------------
| 3. Functional & Taxonomic Scoring    |
|    → Coding probability              |
|    → Species likelihood score        |
|    → Vertebrate vs contamination     |
----------------------------------------
        ↓
Integrated Evidence:
  - Coding potential
  - Evolutionary signal
  - Species consistency
  - aDNA damage pattern

