library(reshape2)
library(ggplot2)
library(ggthemes)
library(ggpubr)
library(rethinking)
library(dplyr)
library(tidyverse)
library(WRS2)
library(purrr)


x <- summaries$ABS
y <- summaries$AAS
model <- ABSmodel

visualisePosteriors <- function(x, y, model)
{
  
g <- ggplot()+geom_point(aes(x=x,y=y), alpha = 0.2)+theme_tufte()  
post <- extract.samples( model)
a_map <- mean(post$a)
bABS_map <- mean(post$bABS)
line <- function (x) {a_map + bABS_map * x} 
g + geom_function(fun = line)
}
