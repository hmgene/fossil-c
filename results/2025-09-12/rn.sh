
if [ -n `find ../../ -size +30M -print -quit`];then
	git add -A
	git commit -am "up"
	git push
else
	echo "remove big files:"
	find ../../ -size +30M
fi

