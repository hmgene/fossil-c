
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
