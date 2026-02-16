#!/usr/bin/perl
use strict;
use warnings;

# Percentiles to use
my @p = (0.01,0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.99);

my %r;       # $r{length}{sample} = count
my %samples; # record sample names

########################################
# Read FASTA files from ARGV
########################################
foreach my $file (@ARGV) {
    # extract folder name as sample
    my $sample = $file;
    if ($sample =~ m|([^/]+)/scaffolds\.fasta$|) {
        $sample = $1;
    }
    $samples{$sample} = 1;

    open(my $fh, '<', $file) or die "Cannot open $file: $!";
    while (<$fh>) {
        chomp;
        next unless /^>/;
        if (/length_(\d+)/) {
            $r{$1}{$sample}++;
        }
    }
    close($fh);
}

########################################
# Prepare per-sample sorted arrays
########################################
my %sample_lengths;
foreach my $sample (sort keys %samples) {
    my @lengths;
    foreach my $len (sort { $a <=> $b } keys %r) {
        push @lengths, ($len) x ($r{$len}{$sample} // 0);
    }
    $sample_lengths{$sample} = \@lengths;
}

# Prepare global array
my @all_lengths;
foreach my $len (sort { $a <=> $b } keys %r) {
    my $count = 0;
    $count += $_ for values %{ $r{$len} };
    push @all_lengths, ($len) x $count;
}

########################################
# Compute percentile boundaries per sample & global
########################################
my %perc_boundaries; # sample => arrayref of percentile lengths

foreach my $sample (sort keys %samples) {
    my $arr = $sample_lengths{$sample};
    my $n = scalar @$arr;
    my @vals;
    foreach my $perc (@p) {
        push @vals, ($n>0) ? $arr->[ int($perc*($n-1)) ] : 0;
    }
    $perc_boundaries{$sample} = \@vals;
}

# Global
my $n_global = scalar @all_lengths;
my @global_vals = map { ($n_global>0) ? $all_lengths[ int($_*($n_global-1)) ] : 0 } @p;
$perc_boundaries{"GLOBAL"} = \@global_vals;

########################################
# Print table header
########################################
print "Percentile_Interval";
foreach my $sample (sort keys %samples) { print "\t$sample" }
print "\tGLOBAL\n";

########################################
# Print MIN row
########################################
print "[MIN,MIN]";
foreach my $sample (sort keys %samples) {
    my $arr = $sample_lengths{$sample};
    my $val = @$arr ? $arr->[0] : 0;
    print "\t$val";
}
my $val = @all_lengths ? $all_lengths[0] : 0;
print "\t$val\n";

########################################
# Print percentile interval rows
########################################
my @sorted_samples = sort keys %samples;
for (my $i=0; $i < @p; $i++) {
    my $start_val = ($i==0) ? $all_lengths[0] : $perc_boundaries{"GLOBAL"}->[$i-1];
    my $end_val   = $perc_boundaries{"GLOBAL"}->[$i];

    # For the last percentile, make the interval closed [start,end]
    if ($i == $#p) {
        printf "[%d,%d]", $start_val, $end_val;
    } else {
        printf "[%d,%d)", $start_val, $end_val;
    }

    foreach my $sample (@sorted_samples) {
        my $val = $perc_boundaries{$sample}->[$i];
        print "\t$val";
    }

    # global
    my $val = $perc_boundaries{"GLOBAL"}->[$i];
    print "\t$val\n";
}

########################################
# Print MAX row
########################################
print "[MAX,MAX]";
foreach my $sample (@sorted_samples) {
    my $arr = $sample_lengths{$sample};
    my $val = @$arr ? $arr->[-1] : 0;
    print "\t$val";
}
my $val = @all_lengths ? $all_lengths[-1] : 0;
print "\t$val\n";

