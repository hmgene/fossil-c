#bigdata/fastp/QGL/Brachy_v_sedi.fastp.json
#for f in bigdata/fastp/QGL/*.json;do
for f in bigdata/fastp/gxyL/*.json;do
    s=${f##*/};s=${s%.fastp.json};
    cat $f | perl -ne 'chomp;; my $s="'$s'";
        if(!$h && $_=~/duplication/){ $h=1;}
        if($h && $_=~/\"rate\": ([\d\.]+)/){
            print "$s\t$1\n";
            exit;
        }
    '   
done


