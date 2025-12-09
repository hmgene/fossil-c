#for f in ../../bigdata/centrifuge/results/*.krreport.txt;do
#    n=${f##*/};n=${n%.krreport*};
#    cat $f | awk '$4=="S"' | sort -nrk 3 | head -n 5 | awk -v OFS="\t" -v n=$n '{print n,$6;}' 
#done > tt

cat tt | perl -e 'use strict;
    my %r=();
    while(<>){chomp;my($n,$v)=split/\s+/,$_;
        push @{$r{$n}},$v;
    }
    print join("\t","sample",map{ "top$_" }  1..5 ),"\n";
    foreach my $n (keys %r){
        print join("\t",$n,@{$r{$n}}),"\n";
    }
' > summ.csv
