source("utils/plotPriors.R")


library(ggplot2)
library(ggthemes)
library(gridExtra)
library(kableExtra)
library(viridis)
library(rethinking)
library(ggpubr)
library(tidyverse)
library(GGally)
library(dagitty)
library(reshape)

summaries <- readRDS(file = "datasets/Summaries.rds")



summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)
summaries$group <- as.factor(summaries$group)
summaries$groupID <-  as.integer( as.factor(summaries$group) )



LotsOfInteractionsModel3 <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


LotsOfInteractionsModel3ulam <- ulam(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

# FinalHMC <- ulam(
#   alist(
#     AdiffS ~ dnorm( mu, sigma ),
#     mu <- a + bADS[groupID] * ADS +  bIT[groupID] +
#     bIC[groupID] * IC + bADSIC * ADS * IC+
#     bCBS[groupID] *CBS,
#     a ~ dnorm (0,0.3),
#     bADS[groupID] ~ dnorm(0,.3),
#     bADSIC ~ dnorm(0,.3),
#     bCBS[groupID] ~ dnorm(0,.3),
#     bIT[groupID] ~ dnorm(0,.3),
#     bIC[groupID] ~ dnorm(0,.3),
#     sigma  ~ dexp(1)
#   ),
#   data = summaries
# )
# 
# getwd()
# saveRDS(FinalHMC, file = "models/FinalHMC.rds")

FinalHMC <- readRDS(file = "models/FinalHMC.rds")

traceplot(FinalHMC)

#prior predictive check
summary(summaries)
levels(summaries$group)
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 5  #mean for interventions in treatment
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
prior <- extract.prior(LotsOfInteractionsModel3, n = 1e5)
mu <- link( LotsOfInteractionsModel3 , post=prior , data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AAS")
head(muLong)

ggplot(muLong)+geom_violin(aes(x = group, y = AAS))+theme_tufte()+xlab("")+labs(title = "Simulated priors for ASS by group", subtitle = "(at ADS = CBS = 0, IC at mean = 5, sd = 1)")

ggsave("images/priors1.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             

# now priors for linear regression for IC
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

prior <- extract.prior(LotsOfInteractionsModel3, n = 1e5)
mu <- link( LotsOfInteractionsModel3 , post=prior , data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
priorDF <- cbind(data, mu.mean, mu.HPDI)
priorDF$groupID <- as.factor(groupID)
levels(priorDF$groupID) <- c("control", "empathy", "normative")
colnames(priorDF)[2]<- "group"


ggplot(priorDF, aes(x = IC, y  = mu.mean,  fill = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("AAS")+labs(title = "Simulated priors for attacks vs interventions", subtitle = "(at ADS = CBS = 0, sd = 1)")
ggsave("images/priorsIC1.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             


#Now moving to posterior visualisations
precis(LotsOfInteractionsModel3ulam, depth =2)

#first by group for low ADS and CBS, IC at the mean
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
posterior <- extract.samples(LotsOfInteractionsModel3ulam, n = 1e5)
mu <- link( LotsOfInteractionsModel3ulam, data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AAS")
head(muLong)
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AAS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = 0, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group)) 
                                
                            
ggsave("images/AASvsGROUPatADS0.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             



#now high ADS
ADS <- .5
CBS <- .5
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
posterior <- extract.samples(LotsOfInteractionsModel3ulam, n = 1e5)
mu <- link( LotsOfInteractionsModel3ulam, data=data ) 
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AAS")
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AAS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = .5, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group)) 


ggsave("images/AASvsGROUPatADS05.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             




#Now posteriors for linear regression on IC


# now priors for linear regression for IC
ADS <- 2
CBS <- 2
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

#post <- extract.samples(LotsOfInteractionsModel3, n = 1e5)
mu <- link( LotsOfInteractionsModel3 ,  data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
posteriorDF <- cbind(data, mu.mean, mu.HPDI)
posteriorDF$groupID <- as.factor(groupID)
levels(posteriorDF$groupID) <- c("control", "empathy", "normative")
colnames(posteriorDF)[2]<- "group"
posteriorDF$group <- as.factor(posteriorDF$groupID)



summary(summaries$AAS)
ggplot(summaries)+geom_density(aes(x = AAS))


at <-c(-5,0,5,10) 
labels <- at * sd(summaries$AA)

ggplot(posteriorDF, aes(x = IC, y  = mu.mean,  fill = group, color = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("AAS")+labs(title = "Posteriors for attacks vs interventions", subtitle = "(at ADS = CBS = 2)")

ggsave("images/posteriorsICatADS2.pdf", width = 2, height = 15, units = "cm", dpi = 450)                             











