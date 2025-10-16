#../../bigdata/leehom/Brachy_Blank.fq.gz.n        
#../../bigdata/leehom/Brachy_Blank_r1.fail.fq.gz.n

 ../../bigdata/adapterrm/Brachy_Blank

echo "g,s,x,y" > len.txt
echo "g,s,m,u" > n.txt
for f in ../../bigdata/leehom/*.len;do
	s=${f##*/};s=${s%.len};
	g=`echo $s | cut -d "_" -f 1`
	m=`cat ${f%.len}.fq.gz.n`;
	u=`cat ${f%.len}_r1.fail.fq.gz.n`;

 "reads": 91592712,



	cat $f | awk -v OFS="\t" -v g=$g -v s=$s '{print g,s,$0;}' >> len.txt
	echo "$g,$s,$m,$u" >> n.txt
done


