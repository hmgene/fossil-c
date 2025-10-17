

sum-read(){
echo "sample total_reads R1_total R1_trimmed R2_total R2_trimmed merged" | tr " " "\t"
for f1 in ../adapter/*R1*.adapter;do
    f2=${f1/_R1/_R2}
    s=`echo $f1 | perl -pe '$_=~s#.+/(\w+)_S\d.+#$1#;'`
    ## rerun leehom and save log to avoid this
    n=` cat ../../bigdata/adapterrm/$s.json  | perl -ne 'if( $_=~/"reads": (\d+)/){ print $1; exit;}'`
    r1=`head $f1 | perl -ne 'if($_=~/#N=(\d+)/){ $n=$1;} if($_=~/#M=(\d+)/){ $m=$1;} if($n*$m>0){ print "$n\t$m\n";exit;}'`
    r2=`head $f2 | perl -ne 'if($_=~/#N=(\d+)/){ $n=$1;} if($_=~/#M=(\d+)/){ $m=$1;} if($n*$m>0){ print "$n\t$m\n";exit;}'`
    m=`cat ../../bigdata/leehom/$s.fq.gz.n`
    echo $s $n $r1 $r2 $(( $m * 2 )) | tr " " "\t"
done
}

sum-read > summary.tsv
