blat_example="
psLayout version 3

match   mis-    rep.    N's     Q gap   Q gap   T gap   T gap   strand  Q               Q       Q       Q       T               T       T       T       block   blockSizes      qStarts  tStarts
        match   match           count   bases   count   bases           name            size    start   end     name            size    start   end     count
---------------------------------------------------------------------------------------------------------------------------------------------------------------
47      2       0       0       1       7       1       6       +       6       60      0       56      JH739864        475780  61167   61222   2       32,17,  0,39,   61167,61205,
46      2       0       0       1       8       1       7       +       6       60      0       56      JH739023        2201043 34274   34329   2       32,16,  0,40,   34274,34313,
"

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
usage="$FUNCNAME <psl> [<type=dna|prot>]"
	cat $1 | perl -ne 'chomp;my@d=split/\s+/,$_; my $ty="'${2:-dna}'";
		next unless $d[0]=~/^\d+$/;	
		my ($m,$t,$qn,$qz,$qs,$qe,$tn,$tz,$ts,$te,$n,$l,$qss,$tss)=map {$d[$_]} (0,8..20);	
		my @ql=split/,/,$l;
		my @tl=map { $_ * ( $ty eq "prot" ? 3 : 1) } split/,/,$l;

		my @qs=split/,/,$qss;
		my @ts=split/,/,$tss;
		foreach my $i (0..($n-1)){
			my $ts1= $t=~/.-/ ? $tz - $ts[$i] - $tl[$i] : $ts[$i]; 
			my $te1= $t=~/.-/ ? $tz - $ts[$i] : $ts[$i] + $tl[$i];
			my $qs1= $t=~/-./ ? $qz - $qs[$i] - $ql[$i] : $qs[$i]; 
			my $qe1= $t=~/-./ ? $qz - $qs[$i] : $qs[$i] + $ql[$i];
			print join("\t",$tn,$ts1,$te1,"$qn:$qs1-$qe1$t",$m,$t),"\n";
		}
	'
}
psl2bed-test(){
	echo "$blat_example" | psl2bed -
	echo "$blat_example" | psl2bed - prot
}


