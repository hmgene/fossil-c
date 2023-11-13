sam2bed(){
usage="$FUNCNAME <sam>
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
		if( $_=~/SN:(\w+)\tLN:(\d+)/ ){
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



