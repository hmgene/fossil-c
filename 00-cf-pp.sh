db=bigdata/centrifuge
input=( 
	contaminants
)
for d in ${input[@]};do
	[ -d $db/library/$d ] || echo "#!/bin/bash 
	centrifuge-download -o centrifuge/library/ contaminants
	"
done
