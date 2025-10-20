# fossil-c Bracky & T-rex

### Installation
```
mamba env update -n dino_env -f dino_env.yml

```

### Procedures

1. Adapter handling
```
00-inspect-barcodes.sh
00-leehom-rn.sh
``` 

2. Preparing Genomes 
```
00-download-genome.sh
00-download-ucsc-data.sh
``
3. Mapping Reads
```
01-bwa-pp.sh  ## preprocessing
02-bwa-rn.sh  ## mapping to multi species bigdata/bwa/results
```
4. Bwa Best Scores 

$$ Score = #matches  - #mismatches_and_indels  -  #gapopen $$

```
03-bwa-pl.sh # table of alignment scores => bigdata/bwa_scores/
```

### Structure of DATA
<details>
<summary> bigdata (not shown here ) structure </summary>

```text

    bigdata/
    ├── adapterrm
    ├── bwa
    │   ├── idx
    │   └── results
    ├── centrifuge
    │   └── library
    │       └── contaminants
    ├── fastp
    ├── gatk
    │   └── gatk-4.6.2.0
    │       ├── gatkdoc
    │       └── scripts
    │           ├── cnv_wdl
    │           │   ├── germline
    │           │   └── somatic
    │           ├── mutect2_wdl
    │           │   └── mutect_resources_json
    │           └── sv
    │               └── stepByStep
    ├── genome
    ├── Human
    ├── kr2
    │   ├── genome
    │   │   └── plasmid
    │   ├── library
    │   │   ├── added
    │   │   ├── archaea
    │   │   ├── bacteria
    │   │   ├── fungi
    │   │   ├── human
    │   │   ├── protozoa
    │   │   ├── UniVec_Core
    │   │   └── viral
    │   ├── results
    │   └── taxonomy
    ├── leehom
    ├── Mammuthus
    ├── resources
    ├── results
    ├── stat
    ├── tmp
    │   └── genomes
    └── ucsc
        ├── 2bit
        ├── anno
        │   ├── allMis1
        │   ├── anoCar2
        │   ├── galGal6
        │   └── hg38
        └── fa
```
</details>

### plan
[plan](plan.md)

### Data structure






