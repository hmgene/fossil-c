#!/bin/bash


rc2mat(){
usage="$FUNCNAME <row,columnr,count> [min_per=0.1] [max_per=0.9]"
if [ $# -lt 1 ];then echo "$usage";return;fi
	cat $1 | perl -e 'use strict; my ($m,$M)=('${2:-0.1}','${3:-0.9}');
	my %r=();
	my %c=();
	while(<STDIN>){chomp;my @d=split/\s+/,$_;
		$r{$d[0]}{$d[1]} += $d[2];	
		$c{$d[1]}++;
	}
	my $n=scalar keys %r;
	my @cc=grep{ $c{$_}/$n >= $m && $c{$_}/$n <= $M } sort keys %c;
	print join("\t","rid",@cc),"\n";
	foreach my $i (sort keys %r){
		print join("\t",$i,map { defined $r{$i}{$_} ? $r{$i}{$_} : 0 } @cc),"\n";
	}
	'
}

rc2mat-test(){
echo \
"a	1	1
a	2	1
b	1	1" | rc2mat - $@ 
}
