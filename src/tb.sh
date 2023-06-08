#!/bin/bash



rc2mat(){
usage="$FUNCNAME <row,columnr,count> [min_per=0] [max_per=1]"
if [ $# -lt 1 ];then echo "$usage";return;fi
        cat $1 | perl -e 'use strict; my ($m,$M)=('${2:-0}','${3:-1}');
        my %r=();
        my %c=();
        my $n=0;
        while(<STDIN>){chomp;my @d=split/\s+/,$_;
                $r{$d[0]}{$d[1]} += $d[2];
                $c{$d[1]}++;
                $n++;
        }
        my @cc=grep{ $c{$_}/$n >= $m && $c{$_}/$n <= $M } sort keys %c;
        print join("\t","rid",@cc),"\n";
        foreach my $i (sort keys %r){
                print join("\t",$i,map { defined $r{$i}{$_} ? $r{$i}{$_} : 0 } @cc),"\n";
        }
        '
}


sortbycol(){
usage="$FUNCNAME <mat>"
	cat $1 | perl -e 'use strict;
		my %r=();
		my @c=();
		while(<STDIN>){ chomp; my @d=split/\t/,$_;
			if ($. == 1 ){
				@c=@d[1..$#d];
			}else{
				map{ $r{ $d[0] }{ $c[$_-1] } = $d[$_]; } 1..$#d;
			}	
		}
		my @c1=sort {$a<=>$b} @c;
		print join("\t","rid",@c1),"\n";
		foreach my $i ( keys %r){
			print $i;
			map { print "\t$r{$i}{$_}"; } @c1; 
			print "\n";
		}
	'
}

sortbycol-test(){
echo \
"x	2	1	3
a	1	2	3
b	3	2	1
" | sortbycol -
}

rc2mat-test(){
echo \
"a	1	1
a	2	1
b	1	1" | rc2mat - $@ 
}

