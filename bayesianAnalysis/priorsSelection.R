library(ggpubr)
library(ggplot2)
library(ggthemes)
library("fitdistrplus")


sim <- seq(0,400,by = 1)
p <- ggplot(data = data.frame(count = sim), 
            mapping = aes(x = count))+theme_tufte()

xdnorm <- seq(-4,4,by = 0.01)
pd <- ggplot(data = data.frame(change = xdnorm), 
            mapping = aes(x = change))+theme_tufte()


priorAC <- function(x) dnorm(x,0,1)
pd + stat_function(fun = priorAC)+ggtitle("Prior for activity change")


priorA <- function(x) dcauchy(x,2,10)
pd + stat_function(fun = priorA)+ggtitle("Prior for attacks")+xlim(c(0,60))+xlab("weekly attacks")


sigmas <- rexp(100,3)
ggplot()+ geom_density(aes(x=sigmas))+ggtitle("Prior for sd")+xlab("sd")

priorb <- function(x) dnorm(x,0,.5)
pd + stat_function(fun = priorb)+ggtitle("Prior for activity change")



aa <- rpois(100,3)
ggplot()+ geom_density(aes(x=aa))+ggtitle("Prior for sd")+xlab("sd")


aa <- rlnorm(1e4,0,1)
ggplot()+ geom_density(aes(x=aa))+ggtitle("Prior for attacks")+xlab("sd")+xlim(0,2)

b <- rlnorm( 1e4 , 0 , 1 )
dens( b , xlim=c(0,5) , adj=0.1 )




?dexp

priorHC <- function(x) dnorm(x,0,1)
pd + stat_function(fun = priorHC)+ggtitle("Prior for change in attacks")



getwd()
extraComments <- read.csv("datasets/extraCommentsFinal.csv")
extraCommentsA <- rowSums(extraComments[2:11])
extraCommentsB <- rowSums(extraComments[12:22])
extraCommentsDiff <- extraCommentsA - extraCommentsB
extraCommentsDiffS <- standardize(extraCommentsDiff)
ggplot()+geom_histogram(aes(x=extraCommentsDiffS))
AC <- function(x)dnorm(x,0,1.32)
ggplot()+geom_histogram(aes(x=extraCommentsDiffS,y=..count../sum(..count..)), bins = 30)+
        stat_function(fun = AC)+stat_function(fun=priorAC, color = "red")


getwd()
extraHate <- read.csv("datasets/extraHateFinal.csv")
extraHateA <- rowSums(extraHate[2:11])
extraHateB <- rowSums(extraHate[12:22])
extraHateDiff <- extraHateA - extraHateB
extraHateDiffS <- standardize(extraHateDiff)
ggplot()+geom_histogram(aes(x=extraHateDiffS))
HC <- function(x)dnorm(x,0,1.62)
ggplot()+geom_histogram(aes(x=extraHateDiffS,y=..count../sum(..count..)))+
  stat_function(fun = HC)+stat_function(fun=priorHC, color = "red")













