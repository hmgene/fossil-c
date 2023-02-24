#!/bin/bash


rc2mat(){
usage="$FUNCNAME <row,columnr,count>"
if [ $# -lt 1 ];then echo "$usage";return;fi
	cat $1 | perl -e 'use strict;
	my %r=();
	my %c=();
	while(<STDIN>){chomp;my @d=split/\s+/,$_;
		$r{$d[0]}{$d[1]} += $d[2];	
		$c{$d[1]}++;
	}
	my @cc=sort keys %c;
	print join("\t","rid",@cc),"\n";
	foreach my $i (sort keys %r){
		print $i;
		print join("\t",$i,map { defined $r{$i}{$_} ? $r{$i}{$_} : 0 } @cc),"\n";
	}
	'
}
