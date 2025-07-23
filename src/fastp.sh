fastplong-dn(){
	wget http://opengene.org/fastplong/fastplong
	chmod a+x ./fastplong
	mv ./fastplong `dino binpath`
}
fastplong-cite(){
echo "
Shifu Chen. 2023. Ultrafast one-pass FASTQ data preprocessing, quality control, and deduplication using fastp. iMeta 2: e107. https://doi.org/10.1002/imt2.107
Shifu Chen, Yanqing Zhou, Yaru Chen, Jia Gu; fastp: an ultra-fast all-in-one FASTQ preprocessor, Bioinformatics, Volume 34, Issue 17, 1 September 2018, Pages i884–i890, https://doi.org/10.1093/bioinformatics/bty560
"
}
fastp-sum(){
usage="$FUNCNAME <fasta.json>"
        cat $1 | perl -e 'use strict;
                use JSON;
                my $json=JSON->new;
                my $r=$json->decode( join("\n",<STDIN>));
                my $x=$r->{"summary"}->{"before_filtering"}->{"total_reads"};
                my $y=$r->{"summary"}->{"after_filtering"}->{"total_reads"};
                print "$x\t$y\n";
        '
}

