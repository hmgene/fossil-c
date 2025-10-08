BB=$BASEDIR/bin/`uname -sm | tr " " "_"`
export LD_LIBRARY_PATH=$BB:$LD_LIBRARY_PATH
export PATH=$PATH:$BB

mycat(){
	if [ `file $1 | grep gzip | wc -l ` -gt 0 ];then
		gunzip -dc $1;
	else
		cat $1;
	fi
	
}

other-tools(){
echo "
| name | url |
|:-:|:-:|
| kaiju | https://bioinformatics-centre.github.io/kaiju/downloads.html |
"
}

binpath(){
	echo $BB
}

pslReps(){
	$BB/$FUNCNAME $@;
}
blat(){
	$BB/$FUNCNAME $@;
}
twoBitToFa(){
	$BB/$FUNCNAME $@;
}
faToTwoBit(){
	$BB/$FUNCNAME $@;
}

jellyfish(){
	$BB/$FUNCNAME $@;
}
w2rap-contigger(){
	$BB/$FUNCNAME $@;
/home/hxk728/git/fossil-c/tools/w2rap-contigger/bin/w2rap-contigger
}

