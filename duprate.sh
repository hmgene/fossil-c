
#!/usr/bin/perl
use strict;
use warnings;

my %sum;
my %sum_sq;
my %count;

print "===== PER-SAMPLE DUPLICATION =====\n";
print "Sample\tPercent_Duplication\tEstimated_Library_Size\n";

foreach my $file (@ARGV) {

    # Extract sample name from filename
    my $sample = $file;
    $sample =~ s#.*/##;
    $sample =~ s/\.dedup\.metrics\.txt$//;

    open(my $fh, "<", $file) or die "Cannot open $file: $!";

    while (<$fh>) {
        next if /^#/;
        next if /^LIBRARY/;
        next if /^\s*$/;

        chomp;
        my @f = split /\t/;

        my $dup  = $f[8];
        my $size = $f[9] // "NA";

        print "$sample\t$dup\t$size\n";

        # Group by prefix before "@"
        my ($group) = split /@/, $sample;

        $sum{$group}    += $dup;
        $sum_sq{$group} += $dup * $dup;
        $count{$group}  += 1;

        last;  # only first data row
    }

    close($fh);
}

print "\n===== GROUP AVERAGE DUPLICATION =====\n";
print "Group\tN\tMean_Duplication\tSD\n";

foreach my $g (sort keys %sum) {

    my $n    = $count{$g};
    my $mean = $sum{$g} / $n;

    my $variance = ($sum_sq{$g} / $n) - ($mean * $mean);
    $variance = 0 if $variance < 0;
    my $sd = sqrt($variance);

    printf "%s\t%d\t%.4f\t%.4f\n",
        $g, $n, $mean, $sd;
}

#perl duprate.sh bigdata/bwa/results/*.dedup.metrics.txt

