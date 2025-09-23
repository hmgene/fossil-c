
if [ -n "`find ../../ -size +40M -print -quit | grep -v bigdata`" ];then
	echo "remove big files:"
	find ../../ -size +40M
else
	Rscript -e 'library(rmarkdown);render("README.Rmd")'
	git add -A
	git commit -am "up"
	git push
fi

