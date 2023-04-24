sam2bed(){
usage="$FUNCNAME <sam>"
if [ $# -lt 1 ];then echo "$usage";return; fi
        local n=${2:-${1##*/}};
        cat $1 | perl -ne 'chomp;my@d=split/\t/,$_; my $n="'$n'";
                sub cx{ my ($x)=@_;
		## complexity
                        my $y=0; map { $y += substr($x,$_,1) ne substr($x,$_ + 1,1) ? 1 : 0; } 0..(length($x)-2);
                        return $y/length($x);
                }
                my ($c,$s,$seq)=($d[2],$d[3]-1,$d[9]);
                my $t = ($d[1] & 0x10) >  0 ? "-" : "+";
                my $f = ($d[1] & 0x40) >  0 ? 1 : 0 ;

                my $q=0; ## query pos
                my $g=$s; ## genomic pos

                while($d[5]=~/(\d+)([SNXMID])/g){
                        my ($x,$y)=($1,$2);
                        if($y=~/[SI]/){
                                $q+=$x;
                        }elsif($y=~/[MX=]/){
                                my $ss=substr($seq,$q,$x);
                                my $cx1=cx($ss);
                                print join("\t",$c,$g,$g+$x,"s:$ss,n:$n,f:$f",0,$t),"\n";
                                $q+=$x; $g+=$x;
                        }elsif($y=~/[DN]/){
                                $g+=$x;
                        }else{
                                print {*STDERR} "warning $x$y\n";
                        }
                }
        '
}

