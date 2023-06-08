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
