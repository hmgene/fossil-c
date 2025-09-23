ucsc-urls(){
i=${1:-galGal6}
echo "
https://hgdownload.soe.ucsc.edu/goldenPath/$i/bigZips/genes/$i.refGene.gtf.gz
https://hgdownload.soe.ucsc.edu/goldenPath/$i/bigZips/genes/$i.ensGene.gtf.gz
https://hgdownload.soe.ucsc.edu/goldenPath/$i/database/simpleRepeat.txt.gz
https://hgdownload.soe.ucsc.edu/goldenPath/$i/database/nestedRepeats.txt.gz
"

}
gtf2gene(){
cat $1 | perl -ne 'chomp;my@d=split/\t/,$_;
        if($d[2] eq "transcript" && $d[8]=~/gene_name \"(\w+)\"/){
                print join("\t","$d[0],$d[6],$1",$d[3],$d[4]),"\n";
        }
' | sort -k1,1 -k2,3n |  mergeBed  | tr "," "\t" |\
awk -v OFS="\t" '{print $1,$4,$5,$3,0,$2;}'
}
gtf2exon(){
cat $1 | perl -ne 'chomp;my@d=split/\t/,$_;
	if($d[2] eq "exon" && $d[8]=~/gene_name \"(\w+)\"/){
		print join("\t",$d[0],$d[3],$d[4],$1,0,$d[6]),"\n";		
	}
'
}
ucsc-simplerep2bed(){
#585     chr1    7       2473    trf     6       379.3   6       67      19      608     27      52      1       17      1.54    CCCAAT
cat $1 | perl -ne 'chomp;my@d=split/\t/,$_;
	print join("\t",@d[1..4],0,"+"),"\n";
'
}

ucsc-nestedrep2bed(){
usage='
$FUNCNAME <nestedRepeats.txt>
table schema:
  `bin` smallint(6) NOT NULL default '0',
  `chrom` varchar(255) NOT NULL default '',
  `chromStart` int(10) unsigned NOT NULL default '0',
  `chromEnd` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `score` int(10) unsigned NOT NULL default '0',
  `strand` char(1) NOT NULL default '',
  `thickStart` int(10) unsigned NOT NULL default '0',
  `thickEnd` int(10) unsigned NOT NULL default '0',
  `reserved` int(10) unsigned NOT NULL default '0',
  `blockCount` int(11) NOT NULL default '0',
  `blockSizes` longblob NOT NULL,
  `chromStarts` longblob NOT NULL,
  `blockStrands` longblob NOT NULL,
  `id` int(10) unsigned NOT NULL default '0',
  `repClass` varchar(255) NOT NULL default '',
  `repFamily` varchar(255) NOT NULL default '',
'
if [ $# -lt 1 ];then echo "$usage"; return; fi
        cat $1 | perl -ne 'chomp; my @a=split/\t/,$_;
                my $chr=$a[1];
                my $start=$a[2];
                my $end=$a[3];
                my $name=$a[4];
                my @sizes=split/,/,$a[11];
                my @starts=split/,/,$a[12];
                my @strands=split/,/,$a[13];
                my ($id,$cl,$fm) = @a[14..16];
                for(my $i=0; $i<$a[10];$i++){
                        print $chr,"\t",$start + $starts[$i];
                        print "\t",$start + $starts[$i] + $sizes[$i];
                        print "\t$name:$cl:$fm\t0\t",$strands[$i],"\n";
                }
        '
}

