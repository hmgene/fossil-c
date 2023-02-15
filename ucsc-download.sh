
odir=/mnt/rstor/SOM_GENE_BEG33/data/fossil-c/ucsc
mkdir -p $odir 

o=$odir/genome_info
#curl -L 'https://api.genome.ucsc.edu/list/ucscGenomes' -o $o.json 
#cat ucsc.json | perl -e 'use strict; use JSON;
#	my $json=JSON->new;
#	my $r=$json->decode( join("\n",<STDIN>));
#	print join("\t","id","genome","taxid","sourcename"),"\n";
#	#print join(",",keys %{$r->{ucscGenomes}->{hg38}}),"\n";#->{ucscGenome}->{$s}}),"\n";
#	my %r=();
#	foreach my $s (keys %{$r->{ucscGenomes}}){
#		next if ($s=~/hs1|mm39/);
#		if( $s=~/(\D+)(\d+)$/){
#			$r{$1}{$2} =join( "\t",$s, ( map { $r->{ucscGenomes}->{$s}->{$_} } qw/ genome taxId sourceName/ ) );
#		}
#	}
#	foreach my $s (sort keys %r){
#		L1: foreach my $v (sort {$b<=>$a} keys %{$r{$s}} ){
#			print $r{$s}{$v},"\n";
#			last L1;
#		}
#	}
#	' >  $o.txt  
#
#cat $o.txt | tail -n+2 $o.txt| while read s g t o;do
#		echo "https://hgdownload.soe.ucsc.edu/goldenPath/$s/bigZips/$s.2bit"
#done > $o.2bit.urls
#
#cat $o.txt | tail -n+2 $o.txt| while read s g t o;do
#		echo "https://hgdownload.soe.ucsc.edu/goldenPath/$s/bigZips/$s.fa.gz"
#done > $o.fa.urls


cat $o.fa.urls | while read x;do
	o=$odir/fa; mkdir -p $o
	echo "#!/bin/bash
	cd $o; wget $x ; cd - " | sbatch
done

