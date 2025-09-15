## Trimmed Lengths

    library(data.table)

    ## Warning: package 'data.table' was built under R version 4.4.3

    library(ggplot2)

    ## Warning: package 'ggplot2' was built under R version 4.4.3

    library(dplyr)

    ## Warning: package 'dplyr' was built under R version 4.4.3

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

    #tt=fread("kr_report_domain2phylom.csv")
    tt=fread("len.txt",sep="\t",header=F)
    p=ggplot(tt, aes(x = factor(V2), y = V3, fill = V1)) +
      geom_bar(stat = "identity", position = "identity", alpha = 0.6) +
      labs(x = "V2", y = "V3", title = "Overlayed barplots by V1") +
      theme_minimal() +
      scale_fill_brewer(palette = "Set1")
