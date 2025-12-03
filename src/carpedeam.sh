carpedeam-rn(){
usage="$FUNCNAME <input.fq.gz> <output.fa>"
    carpedeam ancient_assemble <( gunzip -dc $1 | dino fq-trim-n - ) $2 ${2_}_tmp  --threads 4 # --ancient-damage $o_tmp/dmg
}

