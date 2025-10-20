
input=(
Brachy_Blank.fq.gz
Brachy_cells.fq.gz
Brachy_c_sedi.fq.gz
Brachy_vessels.fq.gz
Brachy_v_sedi.fq.gz
Trex_cells.fq.gz
Trex_c_sedi.fq.gz
Trex_ExtrBlank.fq.gz
Trex_vessels.fq.gz
Trex_v_sedi.fq.gz
)
input=( ${input[@]/#/../../bigdata/leehom/} )

head -n 100000 ../../bigdata/kr2/results/*_report.txt | cut -f 1,2,8 | perl -ne 'chomp;
if($_=~ /==> .+\/results\/(\w+)\.k2_report.txt/){
	$s=$1;
}else{
	($p,$t,$n)=split/\t/,$_;	
	if($n eq "unclassified"){
		print join("\t",$s,$p,$t,$n),"\n";
	}elsif( $n=~/^ {3,6}\S/ && $p>= 1){ $n =~ tr/ /_/;
		print join("\t",$s,$p,$t,$n),"\n";
	}
}
'
exit

Rscript <( echo '
library(data.table)
dt <- setDT(read.table("stdin",sep="\t",header=F)); setnames(dt,c("sample", "percent", "reads", "taxon"))
dt_wide <- dcast(dt, sample ~ taxon, value.var = "percent", fill = 0)
fwrite(dt_wide,"kr_report_domain2phylom.csv")
')

