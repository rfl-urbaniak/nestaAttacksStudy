library(ggpubr)
library(ggplot2)
library(ggthemes)


sim <- seq(0,400,by = 1)
p <- ggplot(data = data.frame(count = sim), 
            mapping = aes(x = count))+theme_tufte()

xdnorm <- seq(-4,4,by = 0.01)
pd <- ggplot(data = data.frame(change = xdnorm), 
            mapping = aes(x = change))+theme_tufte()


priorHD <-  function(x) dcauchy(x,1,22)
p + stat_function(fun = priorHD)+xlim(c(0,20))+ggtitle("Prior for hate during")

priorAC <- function(x) dnorm(x,0,1)
pd + stat_function(fun = priorAC)+ggtitle("Prior for activity change")

priorHC <- function(x) dnorm(x,0,1)
pd + stat_function(fun = priorHC)+ggtitle("Prior for change in attacks")




