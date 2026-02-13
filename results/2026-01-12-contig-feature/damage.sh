
input_bam=../../bigdata/bwa/results/Brachy_cells@Brachy_cells_scaffolds_len10k.bam
input_fa=../../bigdata/spades/Brachy_cells/scaffolds_len10k.fasta
o=../../bigdata/mydamage/Bracky_cells
mkdir -p ${o%/*}
#hm bam-reffa $input_bam $input_fa > $o.fa.bed

echo -e "len\tpos\tquery\tref" 
head -n 100000 $o.fa.bed | \
perl -F'\t' -lane 'chomp; my ($chrom,$start,$end,$x,$y) = @F;
        my @xx = split //, $x;
        my @yy = split //, $y;
        my $len= $#xx + 1;
        for my $i (0..$#xx){
            if($xx[$i] ne $yy[$i]){
                print join("\t",$end-$start,int($i/$len/20*100)*20,$xx[$i],$yy[$i]);
            }
        }
'| cut -f 2-4 | sort | uniq -c | sort -nrk1

