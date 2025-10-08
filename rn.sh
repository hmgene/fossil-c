perl -e '
sub match_q_r {
    my ($q,$r) = @_;
    my $lq = length($q);
    my $lr = length($r);

    for my $offset (-5 .. 5) {   # allow ±10bp overhang
        my $start_in_r = $offset < 0 ? 0 : $offset;
        my $start_in_q = $offset < 0 ? -$offset : 0;
        my $len = $lq - $start_in_q;
        $len = $lr - $start_in_r if $start_in_r + $len > $lr;

        next if $len <= 0;

        my $subq = substr($q, $start_in_q, $len);
        my $subr = substr($r, $start_in_r, $len);

        # mismatch count
        my $mis = ($subq ^ $subr) =~ tr/\0//c;

        if ($mis <= 10) {
            return ($start_in_r+1, $mis);  # 1-based position in $r
        }
    }
    return ();  # no match
}

# --- Example usage ---
my $q = "ACGTGCAAAATTT";
my $r = "TTTACGTGCAAAAGGG";

my ($pos,$mis) = match_q_r($q,$r);
if (defined $pos) {
    print "Match at position $pos with $mis mismatches\n";
} else {
    print "No match found\n";
}


'


exit


fastp -i R1.fastq.gz -I R2.fastq.gz -o trimmed.R1.fq.gz -O trimmed.R2.fq.gz \
      --detect_adapter_for_pe





echo "1>CGCCGCCGCCGCCGCCGCTGCCGCCCCGGCTGCCGCGCCGCGCCGCTGCC
TCTGCCCCGGCCGCCCCCGCCGCCGCTGCCGCCGCCGGCCCGCAGCCAGC
CAGGCGGGCGGCCCAGCCCGCCTGAGCCCGCAGCGGCTGCCGCCGCAGCG
TCGGGTCGCTGGGTGCGCGGGCTACCGCGGACCGAGCGGACCCGAGTGGG
CGACCAGGCGCTTGCCCGCCCAGTGCCACTGCCGCCGCTTCCTCGCCGGA
GCACAGGACCAGACACCTCCAGCGCCCGCTGCTGCTGCCGATGCGGCCCG
GACACTTTTAGCTGGGCGGGAGGGCTGGAGAGCCGGGGGCCGCCGAGAAC
CGCCAGCGAGCTGTGCCGAGAGCCGCGCCGACCCGCTGCGATCAGGGACA
GGCGCCCGCCCGCCGCCGCCGCCTGGC" > a.fa 
echo "
dino  kraken2 --report a --db bigdata/kr2_v2 a.fa
"

exit



gunzip -dc /mnt/vstor/SOM_GENE_BEG33/data/082725_NovaSeq-X_A_lane2/Brachy_Blank_S9_L002_R1_001.fastq.gz | sed -n '2~4p' | head -n 10000 \
	 | awk  '{ print index($1,"AGATCGGAAGAGCACACGTCTGAACTCCAGTCA");}' | sort | uniq -c | sort -nrk 1 | head 

