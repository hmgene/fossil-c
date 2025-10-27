#Read1 before filtering:
#total reads: 45796356
#total bases: 6915249756
#Q20 bases: 6589766447(95.2933%)
#Q30 bases: 6099913605(88.2096%)
#Q40 bases: 6099913605(88.2096%)
#
#Read2 before filtering:
#total reads: 45796356
#total bases: 6915249756
#Q20 bases: 6549994714(94.7181%)
#Q30 bases: 5988113352(86.5929%)
#Q40 bases: 5988113352(86.5929%)
#
#Read1 after filtering:
#total reads: 44607373
#total bases: 4876499276
#Q20 bases: 4769824475(97.8125%)
#Q30 bases: 4540224911(93.1042%)
#Q40 bases: 4540224911(93.1042%)
#
#Read2 after filtering:
#total reads: 44607373
#total bases: 5047849723
#Q20 bases: 4986050463(98.7757%)
#Q30 bases: 4806442075(95.2176%)
#Q40 bases: 4806442075(95.2176%)

for f in bigdata/fastp/*/*.out;do
    g=`echo $f | cut -d "/" -f 3`
    n=${f##*/};n=${n%.out}
    cat $f  | perl -ne 'chomp;
        if( $_=~/Read1/){ $r="R1";}
        if( $_=~/Read2/){ $r="R2";}
        if( $_=~/before/){ $t="before";}
        if( $_=~/after/){ $t="after";}
        if( $_=~/total reads: (\d+)/){
                print join("\t","'$n'","'$g'",$t,$r,$1),"\n";
        }
    '
done | python <( echo '
import sys
import re
import pandas as pd

columns = ["Sample", "Param", "Stage", "Read", "Count"]
df = pd.read_csv(sys.stdin, sep="\t",names=columns)


agg = df.groupby(["Sample", "Param", "Stage"], as_index=False)["Count"].sum()
pivot = agg.pivot(index=["Sample", "Param"], columns="Stage", values="Count").reset_index()
pivot["Percent_Remaining"] = (pivot["after"] / pivot["before"]) * 100
pivot["Reads_Lost"] = pivot["before"] - pivot["after"]
pivot["Total_Reads"] = pivot["before"]
wide = pivot.pivot(index="Sample", columns="Param", values="Percent_Remaining")
wide = wide.round(2)[sorted(wide.columns, key=lambda x: wide[x].mean(), reverse=True)]
total_reads = pivot.groupby("Sample")["before"].first()
wide["Total_Reads"] = total_reads


print("=== Percent Remaining per Param ===")
print(wide)
wide.to_csv("results/2025-10-27-fastp/fastp_summary.tsv",sep="\t")
print("=== Details===")
print(pivot)
')

