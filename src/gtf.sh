

gtf2exonbed(){
usage="$FUNCNAME <gtf>"
if [ $# -lt 1 ];then echo "$usage";return;fi
	cat $1 | perl -ne 'chomp;my@d=split/\t/,$_; 
		if( $d[2] eq "exon" ){ 
			print join("\t",$d[0],$d[3],$d[4],$d[8]=~/gene_name \"(.+)\"/,0,$d[6]),"\n";
		}
	' | sort -u  
}

