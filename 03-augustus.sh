input=(
    bigdata/spades/Brachy_*/scaffolds_len10k.fasta
)
for i in ${input[@]};do
n=`echo $i | cut -d "/" -f 3`
o=bigdata/augustus/$n.gff
[ -s $o ] || echo "#!/bin/bash
augustus --species=chicken $i > $o \
" | sbatch --mem=24g -c 6 -o $o.out
    echo -e "gene_len\tnum_exons\tcount" > $o.stat
    cat $o |  perl -e 'use strict; 
        my $B=100;
        my %r=(); my $c=""; my $l=0; my $t="";
        while(<>){chomp;
            if($_=~/(\w+).+gene\t(\d+)\t(\d+)/){ $l=int( ($3-$2)/$B )* $B; }
            if($_=~/transcript_id \"([^\"]+)/){ $t=$1; }
            if($_=~/(\w+).+CDS\t(\d+)\t(\d+)/){ $r{$t}{$l}++; }
        }
        my %r2=();
        foreach my $t (keys %r){
        foreach my $l (keys %{$r{$t}}){
            $r2{ $l."\t".$r{$t}{$l} }++;
        }}
        map { print $_,"\t",$r2{$_},"\n";} keys %r2;
    ' >> $o.stat
done

