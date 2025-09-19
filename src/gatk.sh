
gatk=bigdata/gatk/gatk-4.6.2.0/gatk
gatk(){
	$gatk $@
}
gatk-dn(){
	if [ ! -s $gatk ]; then 
		o=${gatk%/*}
		mkdir -p $o;cd $o
		wget https://github.com/broadinstitute/gatk/releases/download/4.6.2.0/gatk-4.6.2.0.zip
		unzip gatk-4.6.2.0.zip
	fi
}
gatk-run(){
	usage="$FUNCNAME <prefix/sample_name> <bam> <ref.fa> [thread=8]"
	if [ $# -lt 3 ];then echo "$usage";return;fi

	# e.g., output/Brachy_Blank
	sample=${1##*/}; # Bracky_Blank
	odir=${1%/*};   # output 
	mkdir -p $odir
	input_bam=$2;   # e.g., Brachy_Blank@galGal6.DR.bam
	ref=$3;         # e.g., galGal6.fa
	threads=${4:-8};

	# Output naming
	dedup_bam="$odir/${sample}.dedup.bam"
	rg_bam="$odir/${sample}.dedup.rg.bam"
	final_bam="$odir/${sample}.final.bam"
	gvcf="$odir/${sample}.g.vcf.gz"

	echo "Step 1: Mark Duplicates"
	gatk --java-options "-Xmx32G" MarkDuplicates -I "$input_bam"  -O "$dedup_bam" \
	    -M "$odir/${sample}.dedup.metrics.txt" --REMOVE_DUPLICATES true

	echo "Step 2: Add or Replace Read Groups"
	gatk --java-options "-Xmx16G" AddOrReplaceReadGroups  -I "$dedup_bam"  -O "$rg_bam" \
	    -RGID "$sample"  -RGLB "lib1"  -RGPL "illumina"  -RGPU "unit1"  -RGSM "$sample"

	echo "Step 3: Index BAM"
	samtools index "$rg_bam"

	echo "Step 4: HaplotypeCaller (GVCF mode)"
	gatk --java-options "-Xmx32G" HaplotypeCaller -R "$ref"  -I "$rg_bam"  -O "$gvcf" \
	    -ERC GVCF  --sample-name "$sample" --native-pair-hmm-threads "$threads" \
	    --bam-output $final_bam
	samtools index $final_bam

	echo "Done! Output GVCF: $gvcf"
	echo "Done! Output BAM: $final_bam"
}
