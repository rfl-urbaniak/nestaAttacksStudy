library(ggpubr)
library(ggplot2)
library(ggthemes)


sim <- seq(0,400,by = 1)
p <- ggplot(data = data.frame(count = sim), 
            mapping = aes(x = count))+theme_tufte()



priorHA <-  function(x) dcauchy(x,1,22)
p + stat_function(fun = priorHA)+xlim(c(0,20))+ggtitle("Prior for hate after")

priorHB <-  function(x) dcauchy(x,1,22)
p + stat_function(fun = priorHA)+xlim(c(0,20))+ggtitle("Prior for hate before")


priorAB <- function(x) dcauchy(x,23,22)
p + stat_function(fun = priorAB)+xlim(c(0,100))+ggtitle("Prior for activity before")

priorAB <- function(x) dnorm(x,23,30)
p + stat_function(fun = priorAB)+xlim(c(0,100))+ggtitle("Prior for activity before")

priorAA <- function(x) dcauchy(x,23,22)
p + stat_function(fun = priorAB)+xlim(c(0,100))+ggtitle("Prior for activity before")

priorAA <- function(x) dnorm(x,23,30)
p + stat_function(fun = priorAB)+xlim(c(0,100))+ggtitle("Prior for activity before")



