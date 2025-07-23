BB=$BASEDIR/bin/`uname -sm | tr " " "_"`
export LD_LIBRARY_PATH=$BB:$LD_LIBRARY_PATH
export PATH=$PATH:$BB

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

