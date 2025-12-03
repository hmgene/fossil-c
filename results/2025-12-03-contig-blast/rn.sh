input=(
../../bigdata/blast/Bracky_Blank.unc.K0PYKSCA014-Alignment-HitTable.csv  
../../bigdata/blast/Bracky_cells.unc.K0M7FNPR016-Alignment-HitTable.csv
)

output=data/blast_res.tsv
echo "sample fa_id query_len species" | tr " " "\t" > $output
for i in ${input[@]};do
    o=${i##*/};o=${o%.*-Alignment*};
    cat $i | perl -e 'use strict;
        my %r=();
        while(<>){chomp;my@d=split/,/,$_; $r{$d[0]}{$d[11]}{ $d[1]."\t".($d[7]-$d[6]+1) }++; }
        foreach my $i (keys %r){
            my @x=sort {$b<=>$a} keys %{$r{$i}}; 
            if (my ($first_key) = each %{$r{$i}{$x[0]}}) { print "$i\t$first_key\n"; } #first entry only
            #map { print "$i\t$_\n"; } keys %{$r{$i}{$x[0]}};
        }
    ' | sort -u | while read i j k ;do
        curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=$j&rettype=gb&retmode=text" \
        | grep "^  ORGANISM" | sed 's/^  ORGANISM  //' | awk -v OFS="\t" -v o=$o -v i=$i -v k=$k '{print o,i,k,$0;}' 
    done 
done >> $output
