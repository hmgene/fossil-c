species=(
	allMis1
        anoCar2
        galGal6
        hg38
)

for p in "${species[@]}"; do
    dino ucsc-urls "$p" | grep -v "^$" | while read -r url; do
        f="bigdata/ucsc/anno/$p/${url##*/}"
        if [ ! -s "$f" ]; then
            if curl --head --silent --fail "$url" >/dev/null; then
                echo "URL exists, would download: $url"
                 wget "$url" -O "$f"
            else
                echo "URL not exists: $url"
            fi
        else
            echo "File already exists: $f"
        fi
    done
done

#for p in ${species[@]};do
#dino ucsc-urls $p | grep -v "^$" | while read -r url;do
#	f=bigdata/ucsc/anno/$p/${url##*/};	
#	if [ ! -s $f ];then
#		if curl --head --silent --fail "$url" >/dev/null; then
#			echo " #wget $url -O $f "
#	    	else
#			    echo "$url not exists"
#
#	else
#		echo "$f exists"
#			
#	fi
#done
#done

