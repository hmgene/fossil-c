sam2score(){
usage="$FUNCNAME <sam.rg.sam> [tag=sample]"; if [ $# -lt 1 ];then echo "$usage";return;fi
cat $1 | perl -e 'use strict; my $tag="'${2:-no}'";
my %r=();
sub mx{ my ($x,$y)=@_; return defined $x && $x > $y ? $x : $y;}
my %col=();
while (<>) { chomp; my @f = split(/\t/, $_);
    next if $f[0] =~ /^@/;
    my $len = length($f[9]);
    my ($nm, $xm, $xg, $xt,$rg) = (0, 0, 0, "",$tag);
    for my $i (11 .. $#f) {
        if ($f[$i] =~ /^NM:i:(\d+)/) { $nm = $1; } # num distance (including indels) 
        if ($f[$i] =~ /^XM:i:(\d+)/) { $xm = $1; } # mismatches 
        if ($f[$i] =~ /^XG:i:(\d+)/) { $xg = $1; } # num gaps (contiguous indels)
        if ($f[$i] =~ /^XT:A:(\w)/)  { $xt = $1; } # uniqness
        if ($f[$i] =~ /^RG:Z:(\S+)/){ $rg= $1;}
    }
    if ($xt eq "U") {
        my $matches = $len - $nm;  # approx number of matches
        my $score   = ($matches - $nm - $xg); # / ($len || 1); # avoid /0
	    #print join("\t",$f[0],$rg,$score),"\n";
        $r{ $f[0]."\t".$f[9] }{$rg} = $score;
        $col{$rg} ++;
    }
}
my @cols=sort keys %col;
print join("\t","id","seq",@cols),"\n";
foreach my $i (keys %r){
    print $i;
    map { print "\t", defined $r{$i}{$_} ? $r{$i}{$_} : 0;  } @cols;
    print "\n";
}
'
}
score-max(){
cat $1 | awk '{ if($3 > max[$1]) { max[$1]=$3; name[$1]=$2 } all[$1]=(all[$1]?all[$1]","$2:$2) }
     END { for(i in max) print i,  name[i], max[i] }' OFS="\t" 
}

sam2bed(){
usage="$FUNCNAME <sam+header>
ref: https://samtools.github.io/hts-specs/SAMv1.pdf
"
if [ $# -lt 1 ];then echo "$usage";return; fi
        cat $1 | perl -e '
	#@SQ     SN:JH731052     LN:57586
	my %r=();
	sub cx{ my ($x)=@_;
	## complexity
		my $y=0; map { $y += substr($x,$_,1) ne substr($x,$_ + 1,1) ? 1 : 0; } 0..(length($x)-2);
		return $y/length($x);
	}
	while(<STDIN>){ chomp;my@d=split/\t/,$_; 
		if( $_=~/SN:(.+)\tLN:(\d+)/ ){
			print "$1 $2\n";
			$r{ $1 } = $2; next;
		}
                my ($c,$s,$seq)=($d[2],$d[3]-1,$d[9]);
                my $t = ($d[1] & 0x10) >  0 ? "-" : "+";

                my $q=0; ## query pos
                my $g=$s; ## genomic pos
                while($d[5]=~/(\d+)([SNXMID])/g){
                        my ($x,$y)=($1,$2);
                        if($y=~/[SI]/){
				next if( $r{$c} < $g+$x);
				my $n=join(",", $d[0],$d[5],$q,$q+$x,lc substr($seq,$q,$x),$t);
				print join("\t",$c,$g,$g+$x,$n,0,$t),"\n";
                                $q+=$x;
                        }elsif($y=~/[MX=]/){
				next if( $r{$c} < $g+$x);
				my $n=join(",", $d[0],$d[5],$q,$q+$x,uc substr($seq,$q,$x),$t);
				print join("\t",$c,$g,$g+$x,$n,0,$t),"\n";
                                $q+=$x; $g+=$x;
                        }elsif($y=~/[DN]/){
                                $g+=$x;
                        }else{
                                print {*STDERR} "warning $x$y\n";
                        }
                }
	}
        '
}



