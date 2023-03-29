
fa2flat(){
	cat $1 | perl -ne 'chomp;
	if($_=~/^>/){ 
		print "\n" if ($. > 1 );
		print substr($_,1),"\t";
	}else{ print $_; }
'


		
}
flat2fa(){
	cat $1 | awk '{ print ">"$1"\n"$2;}'
}

