
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
