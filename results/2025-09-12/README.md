## Trimmed Lengths

    library(data.table)

    ## Warning: package 'data.table' was built under R version 4.2.3

    library(ggplot2)
    library(dplyr)

    ## Warning: package 'dplyr' was built under R version 4.2.3

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     between, first, last

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    tt <- fread("len.txt", sep="\t", header=FALSE)
    setnames(tt,c("group","sample","read_len","count"))
    tt$sample <- factor(tt$sample , levels = unique(tt$sample))
    tt[, type := sub("^[^_]+_(.*)$", "\\1", sample)]

    ggplot(tt, aes(x = read_len, y = count, color = type)) +
      geom_line(alpha = 0.7) +
      facet_wrap(~group, scales = "free") +   
      labs(x = "read_len", y = "count", title = "Distribution of Read_len") +
      theme_minimal() +
      theme(legend.position = "bottom")

![](README_files/figure-markdown_strict/setup-1.png)
