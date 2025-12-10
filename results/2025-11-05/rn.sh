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
    my @cc=sort keys %r;
    print join("\t","rank",@cc),"\n";
    print join("\t","unclassified",map{ "$r{$_}[0][1]" } @cc),"\n";
    print join("\t","root",map{ "$r{$_}[1][1]" } @cc),"\n";
    foreach my $i (2..6){
        print join("\t","top".($i-2),map{ "$r{$_}[$i][0] ($r{$_}[$i][1])" } @cc),"\n";
    }
' > summ.tsv
