blat_example="
psLayout version 3

match   mis-    rep.    N's     Q gap   Q gap   T gap   T gap   strand  Q               Q       Q       Q       T               T       T       T       block   blockSizes      qStarts  tStarts
        match   match           count   bases   count   bases           name            size    start   end     name            size    start   end     count
---------------------------------------------------------------------------------------------------------------------------------------------------------------
47      2       0       0       1       7       1       6       +       6       60      0       56      JH739864        475780  61167   61222   2       32,17,  0,39,   61167,61205,
46      2       0       0       1       8       1       7       +-       6       60      0       56      JH739023        2201043 34274   34329   2       32,16,  0,40,   34274,34313,
"
psl-max(){
#match  mis-    rep.    N's     Q gap   Q gap   T gap   T gap   strand  Q               Q       Q       Q       T               T       T       T       block   blockSizes      qStarts  tStarts
#       match   match           count   bases   count   bases           name            size    start   end     name            size    start   end     count
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#28     0       0       0       0       0       0       0       ++      Brachy_cid-2_archosaur_1        28      0       28      chr18   11373140        9189523 9189607 1       28,     091
        cat $1 | perl -e 'use strict;
        my %r=();
        while(<STDIN>){chomp;
                next unless $_=~/^\d+/;
                my @d=split/\t/,$_;
                # id, m -M, t-gap
                $r{$d[9]}{ $d[0] - $d[1] }{ $d[6] }{ $_ }++;
                #print join("\t", map{ $d[$_] } (9,0,1,6)),"\n";
        }
        foreach my $i (keys %r){
                my @x=sort {$b<=>$a} keys %{$r{$i}};
                my @y=sort {$a<=>$b} keys %{$r{$i}{$x[0]}};
                my @z=keys %{$r{$i}{$x[0]}{$y[0]}};
                print join("\n",map { $_=~s/^(\d+\t\d+)/$1,U=$#z/;$_} @z),"\n";
        }
        '
}


blat-summary(){
usage="$FUNCNAME <psl> [<psl> .. ]";
if [ $# -lt 1 ];then echo "$usage";return; fi
for f in $@;do
        s=${f##*\@};s=${s%.psl};
        cat $f | awk -v OFS="\t" -v s=$s '{ print s,$0;}'
done | perl -e 'use strict; my %r=();
        while(<STDIN>){chomp; my ($s, @d)=split/\s+/,$_;
                next unless ($d[0]=~/^\d+/);
                my $m=$d[0];
                my $M=$d[1];
                my $D=$d[5];
                my $qid=$d[9];
                $r{$qid}{$m-$M-$D}{$s} ++;
        }
        foreach my $qid (keys %r){
                my @x=sort {$b<=>$a} keys %{$r{$qid}};
                my @y=keys %{$r{$qid}{$x[0]}};
  #              next if $#y > 0;
                map {
                        print join("\t",$qid,$_,$x[0]),"\n";
                } keys %{$r{$qid}{$x[0]}};
        }
' 
}
blat-summary-test(){
	echo "$blat_example" | blat-summary -
}

psl2bed(){
usage="$FUNCNAME <psl|pslx> [options]
	options:
		<type> : prot|dna(default)
		<coord> : query|target(default)
"; if [ $# -lt 1 ];then echo "$usage";return;fi

local x=`echo ${@:2} | tr " " ","`
	cat $1 | perl -ne 'chomp;my@d=split/\s+/,$_; my $x="'$x'";
		next unless $d[0]=~/^\d+$/;	
		my ($m,$M,$t,$qn,$qz,$qs,$qe,$tn,$tz,$ts,$te,$n,$l,$qss,$tss,$qx,$tx,$others)=map {$d[$_]} (0,1,8..22,23..$#d);	
		$qx=~s/,$//; 
		$tx=~s/,$//;
		my @ql=split/,/,$l;
		my @tl=map { $_ * ( $x=~/prot/ ? 3 : 1) } split/,/,$l;

		my @qs=split/,/,$qss;
		my @qxs=split/,/,$qx;
		my @txs=split/,/,$tx;
		my @ts=split/,/,$tss;
		my ($qt,$tt)=(substr($t,0,1),substr($t,length($t)-1,1));
		foreach my $i (0..($n-1)){
			my $ts1= $t=~/\+-/ ? $tz - $ts[$i] - $tl[$i] : $ts[$i]; 
			my $te1= $t=~/\+-/ ? $tz - $ts[$i] : $ts[$i] + $tl[$i];
			my $qs1= $t=~/-\+/ ? $qz - $qs[$i] - $ql[$i] : $qs[$i]; 
			my $qe1= $t=~/-\+/ ? $qz - $qs[$i] : $qs[$i] + $ql[$i];

			if($x=~/query/){
				print join("\t",$qn,$qs1,$qe1,"m=$m,M=$M,qs=$qx,$tn:$ts1-$te1$tt",$m,$qt,$qxs[$i],$txs[$i],$others),"\n";
			}else{
				print join("\t",$tn,$ts1,$te1,"m=$m,M=$M,qs=$qx,$qn:$qs1-$qe1$qt",$m,$tt,$qxs[$i],$txs[$i],$others),"\n";
			}
		}
	'
}
psl2bed-test(){
	echo "$blat_example" | psl2bed - $@
}

psl-bed2mut(){
usage="$FUNCNAME <pslx.bed> [option]
	option: prot|dna(default)
"
if [ $# -lt 1 ];then echo "$usage";return; fi
        cat $1 | perl -ne 'chomp;my@d=split/\t/,$_; my $prot="'${2:-dna}'";
		my $l= 1;
		my $qs=$d[6];
		my $ts=$d[7];
	
		if( $prot eq "prot"){
			$l=3;
			if($d[5] eq "-"){
				$qs=reverse($qs);
				$ts=reverse($ts);
			}
		}
		for( my $i=0; $i <= $d[2]-$d[1] - $l; $i+=$l ){
                        print join("\t",$d[0],$d[1]+$i,$d[1]+$i+$l,$d[5],
                                substr($qs,$i/$l,1), substr($ts,$i/$l,1)),"\n";
                }
        ' | sort -k1,5 | groupBy -g 1,2,3,4 -c 5,6 -o freqdesc,freqdesc

}

blat-parallel-test(){
echo ">a
AAAAAAAAAAAAAAAAAAAAA
>c
CCCCCCCCCCCCCCCCCCCCC
>g
GGGGGGGGGGGGGGGGGGGGG
>t
TTTTTTTTTTTTTTTTTTTTT
" > tmp.a
fo faToTwoBit tmp.a tmp.b
fo blat-parallel tmp.b tmp.a tmp.c 2 -minScore=10 #-minIdentity=10
cat tmp.c
rm -r tmp.*

}
blat-parallel(){
usage="$FUNCNAME <2bit> <fa> <output.pslx> <threads> [blat options]"
if [ $# -lt 4 ];then echo "$usage"; return; fi
	local o=${3%\/}; mkdir -p $o.d;
        split -l 20000000 $2 $o.d/fa.
        local ff=( $o.d/fa.*)
        parallel -j $4 fo blat $1 {} {}.pslx -out=pslx ${@:5}  ::: ${ff[@]}
	first=1;
	for f in $o.d/fa.*.pslx;do 
		if [ $first -eq 1 ];then
			cat $f > $o;first=0;	
		else
			tail -n+6 $f | grep -v '^$'  >> $o
		fi
	done
}

