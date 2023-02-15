BB=$BASEDIR/bin/`uname -sm | tr " " "_"`

blat(){
	$BB/$FUNCNAME $@;
}
