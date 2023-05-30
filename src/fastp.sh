

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

