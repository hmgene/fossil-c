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
        $r{$n}{$c}=$v;
    }
    print join("\t","sample",map{ "top$_" }  1..7 ),"\n";
    foreach my $n (keys %r){
        my @x = sort {$b<=>$a} keys %{$r{$n}};
        print join("\t",$n, map { "$r{$n}{$_} ( $_ )" } @x),"\n";
    }
' > summ.tsv
