# Fossil-C Bracky & T-rex

### Installation

```
mamba env update -n dino_env -f dino_env.yml
mamba activate dino_env
dino list ## list tools

```

### Procedures

1. Adapter handling

```
00-inspect-barcodes.sh
00-leehom-rn.sh
``` 
[go to results]( results/2025-10-08-read-adapter-positions/README.md  )


2. Preparing Genomes 

```
00-download-genome.sh # => bigdata/genome
00-download-ucsc-data.sh # =>bigdata/ucsc
```

3. Mapping Reads

```
01-bwa-pp.sh  ## preprocessing => bigdata/bwa/idx
02-bwa-rn.sh  ## mapping to multi species => bigdata/bwa/results
```

4. Bwa Best Scores 

$$
\text{Score} = \#\text{matches} - \#\text{mismatches\_and\_indels} - \#\text{gapopen}
$$

```
03-bwa-pl.sh # table of alignment scores => bigdata/bwa_scores/
```
[go to results](results/2025-10-16-taxonomic-authentication/README.md)


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






