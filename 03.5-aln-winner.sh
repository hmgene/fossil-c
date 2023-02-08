#!/bin/bash
ss=(
#trex_cells
#trex_vessels
#bra_cells_merged
#bra_vessels_merged
#ost_cc
#ost_ep
#ost_om
#cara_bone
#cara_muscle
#cara_fossil
)

rr=( allMis1 danRer11 hg38 anoCar2 galGal6 sCam )

odir=mt
mkdir -p $odir
module load samtools
## read tracer
for s in ${ss[@]};do
        if [ -f $odir/$s.txt ];then continue; fi
        echo "$s>>"
        echo -e "sample\treference\tmapq\tlen" > $odir/$s.txt
        for r in ${rr[@]};do
                samtools view -F0x4 bw/$s@$r.bam |\
                perl -ne 'chomp;my@d=split/\t/,$_;
                my $mapq=$d[4];
                my $mapl=$d[5]=~/(\d+)M/? $1 : 0;
                print join("\t",$d[0],"'$r'",$mapq,$mapl),"\n";
                ' >> $odir/$s.txt
        done

        cat $odir/$s.txt |\
        perl -e 'use strict;
                my %r=();
                while(<STDIN>){ chomp;my@d=split/\t/,$_;
                        next if $d[0] eq "sample";
                        $r{$d[0]}{$d[3]}{$d[2]}{$d[1]} ++;
                }
                foreach my $s (keys %r){
                        foreach my $q ( sort {$b<=>$a} keys %{$r{$s}}){
                                foreach my $l (sort {$b<=>$a}  keys %{$r{$s}{$q}} ){
                                        print join("\t",$s,$q,$l,join(",",keys %{$r{$s}{$q}{$l}})),"\n";
                                        last;
                                }
                                last;
                        }
                }
        ' > $odir/$s.win.tt
        echo "$s:"
        cat $odir/$s.win.tt | awk '$2 < 40 { print $4;}' | sort | uniq -c | sort -k1nr | head
        cat $odir/$s.win.tt | awk '$2 >= 40 { print $4;}' | sort | uniq -c | sort -k1nr | head
        cat $odir/$s.win.tt | awk '$2 >= 140 { print $4;}' | sort | uniq -c | sort -k1nr | head

done
