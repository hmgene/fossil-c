
input=(
bigdata/leehom/Brachy_Blank.fq.gz
bigdata/leehom/Brachy_cells.fq.gz
bigdata/leehom/Brachy_c_sedi.fq.gz
bigdata/leehom/Brachy_vessels.fq.gz
bigdata/leehom/Brachy_v_sedi.fq.gz
bigdata/leehom/Trex_cells.fq.gz
bigdata/leehom/Trex_c_sedi.fq.gz
bigdata/leehom/Trex_ExtrBlank.fq.gz
bigdata/leehom/Trex_vessels.fq.gz
bigdata/leehom/Trex_v_sedi.fq.gz
)

fn(){
	echo "#!/bin//bash
	gunzip -dc $1 |  fo fq-len - > $1.len
	" | sbatch --mem=24g -c 4
};export -f fn;

#parallel fn {} ::: ${input[@]}


head -n 100000 bigdata/kr2/results/*_report.txt | cut -f 1,2,8 | perl -ne 'chomp;
#==> bigdata/kr2/results/Trex_vessels.k2_report.txt <==
# 87.89	186523829	unclassified
# 12.11	25700606	root
# 12.07	25623861	  cellular organisms
# 11.62	24654823	    Bacteria
#  8.09	17177842	      Pseudomonadati
#  7.86	16670419	        Pseudomonadota
#  6.97	14790553	          Alphaproteobacteria
#  6.03	12802358	            Hyphomicrobiales
#  2.86	6075988	              Nitrobacteraceae
#  2.12	4494004	                Bradyrhizobium
#
#==> bigdata/kr2/results/Trex_v_sedi.k2_report.txt <==
# 95.62	14490421	unclassified
#  4.38	663635	root
#  4.18	633626	  cellular organisms
#  3.25	493022	    Bacteria
#  2.18	330165	      Pseudomonadati
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

' | Rscript <( echo '
library(data.table)
dt <- setDT(read.table("stdin",sep="\t",header=F))
setnames(dt,c("sample", "percent", "reads", "taxon"))

# pivot wider (percent)
dt_wide <- dcast(dt, sample ~ taxon, value.var = "percent", fill = 0)

print(dt_wide)
')

