library(reshape2)
library(ggplot2)
library(ggthemes)
library(ggpubr)
library(rethinking)
library(dplyr)
library(tidyverse)
library(WRS2)
library(purrr)


visualisePriors <- function(model, dataAsList, N = 100)
{
  prior <- extract.prior( model, n = N )
  mu <- link( model , post=prior, data=dataAsList)  
  mut <- as.data.frame(t(mu))
  mutLong <- melt(mut)
  mutLong$x <- rep(c(-3,3),N)
  ggplot(mutLong)+geom_line(aes(x = x, y = value, group = variable), alpha = 0.2)+theme_tufte()+xlab(names(data)[1])
}

#visualisePriors(100,ABSModel, list(ABS = c(-3,3)))


