#for f in ../../bigdata/centrifuge/results/*.krreport.txt;do
#    n=${f##*/};n=${n%.krreport*};
#    {
#        head -2 $f 
#        cat $f | awk '$4=="S"' | sort -nrk 3 | head -n 5 
#    } | awk -v OFS="\t" -v n=$n '{print n,$2,$6;}' 
#done > tt

cat tt | perl -e 'use strict;
    my %r=();
    while(<>){chomp;my($n,$c,$v)=split/\s+/,$_;
        push @{$r{$n}},[ $v, $c ];
    }
    print join("\t","rank",keys %r),"\n";
    foreach my $i (0..6){
        print join("\t","top$i",map{ "$r{$_}[$i][0] ( $r{$_}[$i][1] )" } keys %r),"\n";
    }
' > summ.tsv
