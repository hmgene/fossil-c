

input=(
../../bigdata/leehom/Brachy_Blank.fq.gz
../../bigdata/leehom/Brachy_cells.fq.gz
../../bigdata/leehom/Brachy_c_sedi.fq.gz
../../bigdata/leehom/Brachy_vessels.fq.gz
../../bigdata/leehom/Brachy_v_sedi.fq.gz
../../bigdata/leehom/Trex_cells.fq.gz
../../bigdata/leehom/Trex_c_sedi.fq.gz
../../bigdata/leehom/Trex_ExtrBlank.fq.gz
../../bigdata/leehom/Trex_vessels.fq.gz
../../bigdata/leehom/Trex_v_sedi.fq.gz
)

for f in ${input[@]/%/.len};do
	n=${f##*/};n=${n%.fq.gz*};
	g=`echo $n | cut -d"_" -f 1`;
	cat $f | awk -v OFS="\t" -v n=$n  -v g=$g '{print g, n,$1,$2;}'
done > len.txt
exit

#library(ggplot2)
#library(patchwork)  # for combining plots
#
## Suppose 'g' is the grouping column with two unique values
#unique_groups <- unique(tt$g)
#
## Create separate plots for each group
#p1 <- ggplot(tt[tt$g == unique_groups[1], ], aes(x = x, y = y, fill = n)) +
#  geom_bar(stat = "identity", position = "identity", alpha = 0.6) +
#  labs(x = "read len.", y = "counts", title = paste("Group", unique_groups[1])) +
#  theme_minimal() +
#  scale_fill_brewer(palette = "Set1")
#
#p2 <- ggplot(tt[tt$g == unique_groups[2], ], aes(x = x, y = y, fill = n)) +
#  geom_bar(stat = "identity", position = "identity", alpha = 0.6) +
#  labs(x = "read len.", y = "counts", title = paste("Group", unique_groups[2])) +
#  theme_minimal() +
#  scale_fill_brewer(palette = "Set1")
#
## Combine side by side
#combined <- p1 + p2
#
## Save
#ggsave("o.png", plot = combined, width = 12, height = 4, dpi = 300)

Rscript <( echo '
	library(ggplot2)
	library(dplyr)
	tt=read.table("stdin");
	colnames(tt)=c("g","n","x","y");
	p=ggplot(tt, aes(x = x, y = y, fill = n)) +
	  geom_bar(stat = "identity", position = "identity", alpha = 0.6) +
	  labs(x = "read len.", y = "counts", title = "Overlayed barplots by Sample") +
	  theme_minimal() + scale_fill_brewer(palette = "Set1") +
	  facet_wrap(~g

	  ggsave("o.png", plot = p, width = 6, height = 4, dpi = 300)


	  p <- ggplot(tt, aes(x = x, y = y, fill = n)) +
  geom_bar(stat = "identity", position = "identity", alpha = 0.6) +
  labs(x = "read len.", y = "counts", title = "Overlayed barplots by Sample") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~Sample, scales = "free_y")  # split by Sample

ggsave("o.png", plot = p, width = 6, height = 4, dpi = 300)
	
')
