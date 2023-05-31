
fa2flat(){
	cat $1 | perl -ne 'chomp;
	if($_=~/^>/){ 
		print "\n" if ($. > 1 );
		print substr($_,1),"\t";
	}else{ print $_; }
'


		
}

fa-rc(){
	fa2flat $1 | perl -ne 'chomp;my ($x,$y)=split/\t/,$_;
		$y=reverse $y;
		$y=~tr/ACGTacgt/TGCAtgca/;	 
		print ">$x\n$y\n";
	'
}

flat2fa(){
	cat $1 | awk '{ print ">"$1"\n"$2;}'
}


fa-split(){
	fa2flat $1 |  split -l $3 - $2.
	for f in $2.*;do
		flat2fa $f  > $f.fa
		rm $f
	done
}

fa-split-test(){
echo ">a
a
b
>b
bbbbb
" | fa-split - tmp 1
}
