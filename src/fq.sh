fq-adapter(){
usage="$FUNCNAME <fq> <fa> [outputtype=seq]
	[outputtype]:
		seq : sequence with tags
		pos : positional distribution
"; if [ $# -lt 2 ];then echo "$usage";return;fi

	local tmpd=`mktemp -d`;
	cat $2 > $tmpd/a
	cat $1 | awk 'NR%4==2' | perl -e 'use strict; my $method="'${3:-seq}'";
	sub min{ my @x=@_; my @y=sort {$a<=>$b} @x; return $y[0]; }
	sub ss {
	    my ($q, $r,$tag,$chop) = @_; my $lenq = length($q);
	    my $hit=0; my @p=(); my @prc=();
	    my @subs=( $q ); #, substr($q,$chop),substr($q,0,- $chop) ); 
	    my @rcsubs = map { my $s = $_; $s =~ tr/ACGT/TGCA/; scalar reverse($s) } @subs;
	    foreach my $q1 (@subs){
		while ($r =~ /($q1)/ig) { push @p, $-[0]; $hit = 1; }
		#$r =~ s/($q1)/"_".$tag.("_" x (length($1)-length($tag)-2))."_" /ieg;
	    }
	    foreach my $q1 (@rcsubs){
		while ($r =~ /($q1)/ig) { push @prc, $-[0]; $hit = 1; }
		#$r =~ s/($q1)/"_"."r$tag".("_" x (length($1)-length($tag)-3))."_" /ieg;
	    }
	    return ($r,join(",",@p),join(",",@prc));
	}

	#print join("\t",ss("ACGT","CGTAAAAAAACGTACGTAC","t",1)),"\n";

	my %h=();
	my $x="";
	my $fh =open (my $fh,"'$tmpd/a'") or die "$!";
	my $chop = 10;
	while(<$fh>) { chomp; 
		if($_=~/^>(\w+)/){ $x=$1; }else{ 
			$h{$x}=$_;
		}
	}
	my %r=();
	my $N=0;
	my %c=();
	while(<>){chomp;
		my ($s,$tmp1,$tmp2)=($_,"","");
		my $pos="";
		foreach my $k (keys %h){
			($s,$tmp1,$tmp2)=ss($h{$k},$s,$k,$chop);
			if($tmp1 ne "" ){ $pos .= "$k:$tmp1;"; }
			if($tmp2 ne "" ){ $pos .= "rc_$k:$tmp2;"; }
		}
		if($pos ne ""){
			map { my ($i,@x)=split /[:,]/,$_; $c{$i}++; map { $r{$_}{$i}++;} @x; } split /;/,$pos;
			#print $s,"\t",$pos,"\n";
		}
		$N++;
	}
	my @cc=sort keys %c;
	print "#N=$N\n";
	print join("\t","pos",@cc),"\n";

	foreach my $x (sort {$a<=>$b} keys %r){
		print $x;
		map { print "\t",defined $r{$x}{$_} ? $r{$x}{$_} : 0; } @cc;
		print "\n";
		
	}
#	print join("\t","pos","all",keys %c),"\n";
#	if($method eq "pos"){
#		foreach my $x ( sort {$a<=>$b} keys %p){
#			print $x;
#			map { 
#				print "\t",defined $p{$x}{$_} ? $p{$x}{$_} : 0;
#
#			} ("all",keys %c);
#			print "\n";
#		}
#	}

	'
}

fq-umi(){
usage="$FUNCNAME <fq> <5umi_len=9>";
if [ $# -lt 2 ];then echo "$usage";return;fi

cat $1 | awk -v umi_len=${2:-9} 'NR%4==1 {header=$0; getline seq; umi=substr(seq,1,umi_len); seq=substr(seq,umi_len+1); 
	getline plus; getline qual; qual=substr(qual,umi_len+1); 
	if (length(seq) >= 10) {
		print header "_UMI:" umi "\n" seq "\n" plus "\n" qual
	}
}' 

}


fq-fil-id(){
usage="$FUNCNAME <fastq>[.gz] <id file> [-v]
        -v : exclude (default include)
"
if [ $# -lt 2 ];then echo "$usage";return;fi

        local tmp=$(mktemp -d)
        cat $2 > $tmp/a
        zcat $1 |\
        perl -e 'use strict; my $v="'${3:-""}'";
        my %r=();
        open(my $fh,"<","'$tmp/a'") or die  $!;
        while(<$fh>){chomp;$r{$_}=1; }
        close($fh);
        #map { print $_,"\n";} keys %r;

        my $ok=0;
        while(<STDIN>){chomp;my @d=split/\s+/,$_;
                if( $. % 4 == 1 ){
                        if($v eq "-v"){
                                $ok= defined $r{substr($d[0],1)} ? 0 : 1;
                        }else{
                                $ok= defined $r{substr($d[0],1)} ? 1 : 0;
                        }
                }
                if($ok){
                        print $_,"\n";
                }
        }
        '
}

fq2flat(){
        cat $1 | perl -ne 'chomp;
		print $_,($.%4==3 ? "\n" : "\t");
'



}

fq-len(){
       cat $1 | perl -e 'use strict;
       my %r=();
       my $B=5;
       while(<STDIN>){chomp;
               if( $. % 4==2){
                       $r{int(length($_)/$B)}++;
               }
       }
       my @i=sort{$a<=>$b} keys %r;
       map{  my $v=defined $r{$_} ? $r{$_} : 0; print $_*$B,"\t",$v,"\n"; } 0..$i[$#i];
       #print join("\t",map{  defined $r{$_} ? $r{$_} : 0 } 0..$i[$#i]),"\n";
       '
}

fq2fa(){
	usage="$FUNCNAME <fq> [<prefix>]"
	if [ $# -lt 2 ];then echo "$usage";return;fi
	cat $1 | perl -ne 'chomp;if( $. % 4 == 2){ $i="'${2:-""}'".int($./4+1);print ">$i\n$_\n";}'
}
fq2fa-test(){
echo "input:"
echo -e "@id\nACGT\n+\nIIII\n@id\nACGT\n+\nIIII"
echo "output:"
echo -e "@id\nACGT\n+\nIIII\n@id\nACGT\n+\nIIII" | fq2fa - "pref"
}

#fa-grep(){
#	usage="$FUNCNAME <fa> <name.list.file>"
#	local tmp=`mktemp -d`;
#	cat $2 > $tmp/a
#	cat $1 | perl -e 'use strict;
#		open(my $fh,"<","'$tmp/a'") or die "$!";
#		my %q=map {chomp; $_=>1 } <$fh>;
#		close($fh);
#
#		my $i="";
#		while(<STDIN>){chomp;
#			if($_=~/^>/){ $i=substr($_,1); 
#			}elsif( defined $q{$i} ){
#				print ">$i\n$_\n";
#			}	
#		}
#
#	'
#}
#fa-grep-test(){
#echo ">1
#AAAAA
#>2
#CCCC" | fa-grep - <( echo "1 2" | tr " " "\n" )
#}
