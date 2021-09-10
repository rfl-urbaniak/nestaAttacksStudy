source("utils/plotPriors.R")

summaries <- readRDS(file = "datasets/Summaries.rds")
summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)
summaries$group <- as.factor(summaries$group)
summaries$groupID <-  as.integer( as.factor(summaries$group) )
#summaries$ApropS <- standardize(summaries$AA/summaries$AB)


ggplot()+geom_histogram(aes(x=summaries$AdiffS))

noChange <-(0 - mean(summaries$Adiff))/sd(summaries$Adiff)
averageChange <- mean(summaries$Adiff[summaries$group == "control"])


# InteractionsModelDiff <- ulam(
#   alist(
#     AdiffS ~ dnorm( mu, sigma ),
#     mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS,
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

#saveRDS(InteractionsModelDiff, file = "models/InteractionsModelDiff.rds")

InteractionsModelDiff <- readRDS(file = "models/InteractionsModelDiff.rds")


precis(InteractionsModelDiff, depth = 2)

# 
# InteractionsModelDiffSD1 <- ulam(
#   alist(
#     AdiffS ~ dnorm( mu, sigma ),
#     mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS,
#     a ~ dnorm (0,1),
#     bADS[groupID] ~ dnorm(0,1),
#     bADSIC ~ dnorm(0,1),
#     bCBS[groupID] ~ dnorm(0,1),
#     bIT[groupID] ~ dnorm(0,1),
#     bIC[groupID] ~ dnorm(0,1),
#     sigma  ~ dexp(1)
#   ), 
#   data = summaries
# )
# 
# saveRDS(InteractionsModelDiffSD1, file = "models/InteractionsModelDiffSD1.rds")

InteractionsModelDiffSD1 <- readRDS(file = "models/InteractionsModelDiffSD1.rds")



#prior predictive check sd =.3
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 5  #mean for interventions in treatment
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
prior <- extract.prior(InteractionsModelDiff, n = 1e4)
mu <- link(InteractionsModelDiff , post=prior , data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS))+theme_tufte()+xlab("")+labs(title = "Simulated priors for change in attacks by group", subtitle = "(at ADS = CBS = 0, IC at mean = 5, sd = .3)")+ylab("change in attacks (standarized)")

ggsave("images/priors03.pdf", width = 20, height = 15, units = "cm", dpi = 450)   


##prior predictive checks sd =1
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 5  #mean for interventions in treatment
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
prior <- extract.prior(InteractionsModelDiffSD1, n = 1e4)
mu <- link( InteractionsModelDiffSD1 , post=prior , data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS))+theme_tufte()+xlab("")+labs(title = "Simulated priors for change in attacks by group", subtitle = "(at ADS = CBS = 0, IC at mean = 5, sd = 1)")+ylab("change in attacks (standardized)")

ggsave("images/priors1.pdf", width = 20, height = 15, units = "cm", dpi = 450)   



#now priors for regression on IC with SD1
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

prior <- extract.prior(InteractionsModelDiffSD1, n = 1e4)
mu <- link(InteractionsModelDiffSD1 , post=prior , data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
priorDF <- cbind(data, mu.mean, mu.HPDI)
priorDF$groupID <- as.factor(groupID)
levels(priorDF$groupID) <- c("control", "empathy", "normative")
colnames(priorDF)[2]<- "group"


ggplot(priorDF, aes(x = IC, y  = mu.mean,  fill = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Simulated priors for attacks vs interventions", subtitle = "(at ADS = CBS = 0, sd = 1)")+xlab("interventions")


ggsave("images/priorsIC1.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             


#now priors for regression on IC with SD.3
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

prior <- extract.prior(InteractionsModelDiff, n = 1e4)
mu <- link(InteractionsModelDiff , post=prior , data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
priorDF <- cbind(data, mu.mean, mu.HPDI)
priorDF$groupID <- as.factor(groupID)
levels(priorDF$groupID) <- c("control", "empathy", "normative")
colnames(priorDF)[2]<- "group"


ggplot(priorDF, aes(x = IC, y  = mu.mean,  fill = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Simulated priors for attacks vs interventions", subtitle = "(at ADS = CBS = 0, sd = .3)")+xlab("interventions")


ggsave("images/priorsIC03.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             


#now moving to posteriors, first by group
#first by group for ADS = CBS = 0
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
posterior <- extract.samples(InteractionsModelDiff, n = 1e5)
mu <- link( InteractionsModelDiff, data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = 0, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group), size = 0.3)+xlab("")+ylab("change in attacks (standardized)") +geom_hline(yintercept = noChange, size = .3)+annotate(geom = "text", label = "no change in count", x = "empathy", y = 0.65, hjust = 0, vjust = 0, size = 4) 


ggsave("images/predictedGroups0.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             



#
#now moving to posteriors, first by group
#first by group for ADS = CBS = -1.3
ADS <- -1.3
CBS <- -1.3
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
posterior <- extract.samples(InteractionsModelDiff, n = 1e5)
mu <- link( InteractionsModelDiff, data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = -1.3, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group), size = 0.3)+xlab("")+ylab("change in attacks (standardized)") +geom_hline(yintercept = noChange, size = .3)+annotate(geom = "text", label = "no change in count", x = "empathy", y = 0.65, hjust = 0, vjust = 0, size = 4) 


ggsave("images/predictedGroups-13.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             




#now moving to posteriors, first by group
#first by group for ADS = CBS = 1.3
ADS <- 1.3
CBS <- 1.3
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
posterior <- extract.samples(InteractionsModelDiff, n = 1e5)
mu <- link( InteractionsModelDiff, data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = 1.3, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group), size = 0.3)+xlab("")+ylab("change in attacks (standardized)") +geom_hline(yintercept = noChange, size = .3)+annotate(geom = "text", label = "no change in count", x = "empathy", y = 0.65, hjust = 0, vjust = 0, size = 4) 


ggsave("images/predictedGroups13.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             



#posteriors by by group
#first by group for ADS = CBS = 2.2
ADS <- 2.2
CBS <- 2.2
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
data
posterior <- extract.samples(InteractionsModelDiff, n = 1e5)
mu <- link( InteractionsModelDiff, data=data ) 
head(mu)
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
head(muLong)
means <-  apply(mu , 2 , mean )
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL

ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS, fill = group, color = group), alpha = 0.2)+theme_tufte()+xlab("")+labs(title = "Posterior dstribution of attack change", subtitle = "(at ADS = CBS = 2.2, IC at mean = 5)")+  geom_hline(data = means, aes(yintercept = means, colour = group), size = 0.3)+xlab("")+ylab("change in attacks (standardized)") +geom_hline(yintercept = noChange, size = .3)+annotate(geom = "text", label = "no change in count", x = "empathy", y = 0.65, hjust = 0, vjust = 0, size = 4) 


ggsave("images/predictedGroups22.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             






# now posteriors  for linear regression for IC
ADS <- -1.3
CBS <- -1.3
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

#post <- extract.samples(LotsOfInteractionsModel3, n = 1e5)
mu <- link( InteractionsModelDiff ,  data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
posteriorDF <- cbind(data, mu.mean, mu.HPDI)
posteriorDF$groupID <- as.factor(groupID)
levels(posteriorDF$groupID) <- c("control", "empathy", "normative")
colnames(posteriorDF)[2]<- "group"
posteriorDF$group <- as.factor(posteriorDF$groupID)


#at <-c(-5,0,5,10) 
#labels <- at * sd(summaries$AA)

ggplot(posteriorDF, aes(x = IC, y  = mu.mean,  fill = group, color = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Posterior regression for attacks vs interventions", subtitle = "(at ADS = CBS = -1.3)")+xlab("interventions")+annotate(geom = "text", label = "no change in count", x = 0, y = 0.65, hjust = 0, vjust = 0, size = 4)+geom_hline(yintercept = noChange, size = .3)+ylim(c(-2,2))



ggsave("images/posteriorsICat-13.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             



# now posteriors  for linear regression for IC
ADS <- 0
CBS <- 0
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

#post <- extract.samples(LotsOfInteractionsModel3, n = 1e5)
mu <- link( InteractionsModelDiff ,  data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
posteriorDF <- cbind(data, mu.mean, mu.HPDI)
posteriorDF$groupID <- as.factor(groupID)
levels(posteriorDF$groupID) <- c("control", "empathy", "normative")
colnames(posteriorDF)[2]<- "group"
#posteriorDF$group <- as.factor(posteriorDF$groupID)


#at <-c(-5,0,5,10) 
#labels <- at * sd(summaries$AA)

ggplot(posteriorDF, aes(x = IC, y  = mu.mean,  fill = group, color = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Posterior regression for attacks vs interventions", subtitle = "(at ADS = CBS = 0)")+xlab("interventions")+annotate(geom = "text", label = "no change in count", x = 0, y = 0.65, hjust = 0, vjust = 0, size = 4) +ylim(c(-2,2)) + geom_hline(yintercept = noChange, size = .3)



ggsave("images/posteriorsICat0.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             




# now posteriors  for linear regression for IC
ADS <- 1.3
CBS <- 1.3
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

#post <- extract.samples(LotsOfInteractionsModel3, n = 1e5)
mu <- link( InteractionsModelDiff ,  data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
posteriorDF <- cbind(data, mu.mean, mu.HPDI)
posteriorDF$groupID <- as.factor(groupID)
levels(posteriorDF$groupID) <- c("control", "empathy", "normative")
colnames(posteriorDF)[2]<- "group"
#posteriorDF$group <- as.factor(posteriorDF$groupID)


#at <-c(-5,0,5,10) 
#labels <- at * sd(summaries$AA)

ggplot(posteriorDF, aes(x = IC, y  = mu.mean,  fill = group, color = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Posterior regression for attacks vs interventions", subtitle = "(at ADS = CBS = 1.3)")+xlab("interventions")+annotate(geom = "text", label = "no change in count", x = 0, y = 0.65, hjust = 0, vjust = 0, size = 4) +ylim(c(-2,2)) + geom_hline(yintercept = noChange, size = .3)



ggsave("images/posteriorsICat13.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             





# now superusers for IC
ADS <- 2.2
CBS <- 2.2
groupID <- 1:3
IC <- 0:20
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

#post <- extract.samples(LotsOfInteractionsModel3, n = 1e5)
mu <- link( InteractionsModelDiff ,  data=data ) 
mu.mean <- apply( mu , 2, mean )
mu.HPDI <- data.frame(t(apply( mu , 2 , HPDI )))
posteriorDF <- cbind(data, mu.mean, mu.HPDI)
posteriorDF$groupID <- as.factor(groupID)
levels(posteriorDF$groupID) <- c("control", "empathy", "normative")
colnames(posteriorDF)[2]<- "group"
#posteriorDF$group <- as.factor(posteriorDF$groupID)





ggplot(posteriorDF, aes(x = IC, y  = mu.mean,  fill = group, color = group))+geom_line()+geom_ribbon(aes(ymin = X.0.89, ymax = X0.89.), alpha = 0.2)+theme_tufte()+ylab("change in attacks (standardized)")+labs(title = "Posterior regression for attacks vs interventions", subtitle = "(at ADS = CBS = 2.2)")+xlab("interventions")+annotate(geom = "text", label = "no change in count", x = 0, y = 0.65, hjust = 0, vjust = 0, size = 4) +ylim(c(-3,3)) + geom_hline(yintercept = noChange, size = .3)



ggsave("images/posteriorsICat22.pdf", width = 20, height = 15, units = "cm", dpi = 450)                             







