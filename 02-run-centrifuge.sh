x=
centrifuge 
   centrifuge -p 8 -x $x -U $i,${i/_R1/_R2} --report-file $o.tsv  > $o.txt
        "
}
