Project: DNA from Two Non-Avian Dinosaurs: Technical Re-Evaluation
Objective: Address reviewer concerns and strengthen authentication, contamination control, and analytical rigor.


| Task | Description | Priority | Responsible |
|------|--------------|-----------|--------------|
| 🧫 Negative controls | Prepare mock and blank libraries | 🔴 High | Wet lab |
| 🧬 Damage profiling | Add UDG-treated SRSLY and damage plots | 🔴 High | Bioinformatics |
| 💻 Pipeline update | Release reproducible SRSLY workflow | 🟠 Medium | Computational |
| 📊 Data QC | Include fragment length, contamination metrics | 🟠 Medium | QC |
| 🧠 Reframe manuscript | Focus on technical validation | 🟢 Low | Writing |


1. Authentication and Contamination Control
<details> <summary>View details</summary>

Reviewer Concern:
Lack of negative controls and contamination monitoring — critical for aDNA authentication.

Planned Actions:

Focus exclusively on SRSLY single-stranded DNA libraries (remove Omni-C).

Add negative controls:

Lambda DNA with poly(dA) template (higher sensitivity).

Extraction blanks and mock library controls.

Modern ostrich and ancient human tooth processed in parallel.

Implement partial UDG treatment to confirm post-mortem deamination.

Add detailed description of lab sterilization and decontamination protocols.

</details>
2. DNA Damage Profiling
<details> <summary>View details</summary>

Reviewer Concern:
No assessment of DNA damage patterns (a core aDNA authentication criterion).

Planned Actions:

Use SRSLY barcode-based read edges to perform damage profiling.

Include soft-clipped regions to better detect terminal cytosine deamination.

Compare UDG-treated vs untreated reads to confirm authenticity.

Visualize with mapDamage-style plots.

</details>
3. Bioinformatics and Mapping Transparency
<details> <summary>View details</summary>

Reviewer Concern:
Unclear mapping pipeline, filtering, and aligner choice.

Planned Actions:

Publish a fully documented pipeline:

Custom SRSLY trimming, UMI deduplication.

Compare BWA-MEM vs BLAT for bias assessment.

Filter by fragment length, mapping quality, and read type.

Include Shankey plots summarizing read origins and mapping results.

Document Centrifuge database construction:

7 vertebrate references + bacteria, virus, and archaea genomes.

</details>
4. Reference and Metagenomic Assignment
<details> <summary>View details</summary>

Reviewer Concern:
Implausible reptile dominance and unclear database curation.

Planned Actions:

Construct a non-redundant reference panel:

Human, chicken, alligator, platypus, ostrich, etc.

Re-run Centrifuge classification with curated references.

Report total read counts per taxon and classification accuracy.

Include complete taxonomic assignment tables as supplementary files.

</details>
5. Positive and Synthetic Controls
<details> <summary>View details</summary>

Reviewer Concern:
Inadequate positive controls for authentication.

Planned Actions:

Generate synthetic damaged DNA datasets from modern genomes (chicken, ostrich).

Use to simulate post-mortem damage and cross-species mapping.

Compare fragment profiles between synthetic and fossil SRSLY reads.

</details>
6. Methodological Justification
<details> <summary>View details</summary>

Reviewer Concern:
Omni-C and sequencing setup not justified.

Planned Actions:

Remove Omni-C datasets entirely.

Use dual unique indices to prevent index hopping.

Use SRSLY UMIs for PCR duplicate removal.

Address G-repeat artifacts and adapter sequence issues.

</details>
7. Data Quality and Filtering
<details> <summary>View details</summary>

Reviewer Concern:
No clear metrics for data quality or filtering.

Planned Actions:

Report:

Read length and insert-size distributions.

Mapping quality and coverage statistics.

Compare with ancient human and modern ostrich controls.

Quantify authentic vs contaminant read fractions.

</details>
8. Interpretation and Presentation
<details> <summary>View details</summary>

Reviewer Concern:
Overstated conclusions and ambiguous visuals.

Planned Actions:

Limit claims to “candidate endogenous fragments” pending confirmation.

Replace pie charts with Shankey plots and summary tables.

Clarify “high-quality reads” criteria and thresholds.

Test for mapping bias to conserved or repetitive regions.

</details>
9. Figures and Comparative Context
<details> <summary>View details</summary>

Reviewer Concern:
No comparison against genuine ancient DNA datasets.

Planned Actions:

Add:

Fragment length plots (fossil vs modern vs aDNA).

Read mapping correlations by tissue type.

Simplify Figures 3–4:

Focus on SRSLY-only data.

Annotate control data sources for clarity.

</details>
10. Overall Manuscript Strategy
<details> <summary>View details</summary>

Refocus:
Reframe as a technical evaluation of DNA preservation using SRSLY.

Emphasis:

Methodological rigor and authentication.

Limitations and reproducibility.

Target Journals:

Nature Communications Biology

eLife

iScience

</details>
