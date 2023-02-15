fq2fa(){
	cat $1 | perl -ne 'chomp;if( $. % 4 == 2){ print ">$.\n$_\n";}'
}
