
for f in ../../bigdata/spades/*/scaffolds.fasta;do
    s=${f%/scaffolds.fasta};
    s=${s##*/}
    cat $f | perl -ne 'if($_=~/>.+length_(\d+)/){ print "$1\t'$s'\n";}' | head -n 1000
done | perl -e 'use strict;
    my %r=();
    my @x=();
    my %c=();
    while(<>){chomp;my @d=split/\t/,$_;
        $r{$d[0]}{$d[1]}++;
        push @x,$d[0];
        $c{$d[1]} ++;
    }
    my @x1=sort {$a<=>$b} @x;
    my $n=$#x1 + 1;
    my $num_bins = 10;
    my $bin_size = int($n / $num_bins);

print "Interval";
foreach my $s (sort keys %c) {
    print "\t$s";
}
print "\n";

for (my $i = 0; $i < $n; $i += $bin_size) {

    my $start = $x1[$i];
    my $end   = ($i + $bin_size < $n) ? $x1[$i + $bin_size] : $x1[-1];

    # collect counts inside this bin
    my %bin_count;

    for (my $j = $i; $j < $i + $bin_size && $j < $n; $j++) {
        my $len = $x1[$j];

        foreach my $s (keys %{ $r{$len} }) {
            $bin_count{$s} += $r{$len}{$s};
        }
    }

    print "[$start,$end)";
    foreach my $s (sort keys %c) {
        print "\t", ($bin_count{$s} // 0);
    }
    print "\n";
}

     
'
