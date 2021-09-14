source("utils/plotPriors.R")

removeX <-   theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

removeY <-   theme(axis.title.y=element_blank(),
                   axis.text.y=element_blank(),
                   axis.ticks.y=element_blank())


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

# FinalHMC <- ulam(
#   alist(
#     AdiffS ~ dnorm( mu, sigma ),
#     mu <- a + bADS[groupID] * ADS + 
#     bIT[groupID] + bIC[groupID] * IC + 
#       bADSIC * ADS * IC+ bCBS[groupID] *CBS,
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

# saveRDS(FinalHMC, file = "models/FinalHMC.rds")

FinalHMC <- readRDS(file = "models/FinalHMC.rds")


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

model <- FinalHMC
ADS <- 0
CBS <- 0
xmin <-  2
ymax <- -3

visGroup <- function (model, ADS, CBS, xmin =2, ymax = -3)
{
groupID <- 1:3
IC <- 5 
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)
posterior <- extract.samples(model, n = 1e5)
mu <- link( model, data=data ) 
colnames(mu) <- levels(summaries$group)
muLong <- melt(mu)
colnames(muLong) <- c("id", "group", "AdiffS")
means <-  round(apply(mu , 2 , mean ), 2)
mu_HPDI <- round(apply( mu , 2 , HPDI ),2)
means <- as.data.frame(means)
means$group <- rownames(means)
rownames(means) <- NULL
meansDisp <- cbind(means,t(as.data.frame(mu_HPDI)))
meansDisp <- meansDisp[,c(1,3,4)]

plot <- ggplot(muLong)+geom_violin(aes(x = group, y = AdiffS), alpha = 0.2)+
  xlab("")+
  labs(title = paste("ADS=", ADS, ", CBS=",  CBS,  sep = ""))+
  theme_tufte()+ylim(c(-4,4))
#+   annotation_custom(tableGrob(meansDisp), xmin=xmin,  ymax=ymax)
return(plot)
}


visGroupA2C_2 <- visGroup(model = FinalHMC, ADS = 2,CBS = -2)
visGroupA2C0 <- visGroup(model = FinalHMC, ADS = 2,CBS = 0 )
visGroupA2C2 <- visGroup(model = FinalHMC, ADS = 2,CBS = 2)

visGroupA0C_2 <- visGroup(model = FinalHMC, ADS = 0,CBS = -2 )
visGroupA0C0 <- visGroup(model = FinalHMC, ADS = 0,CBS = 0 )
visGroupA0C2 <-  visGroup(model = FinalHMC, ADS = 0,CBS = 2)

visGroupA2C_2 <-  visGroup(model = FinalHMC, ADS = 2,CBS = -2 )
visGroupA2C0 <- visGroup(model = FinalHMC, ADS = 2,CBS = 0 )
visGroupA2C2 <- visGroup(model = FinalHMC, ADS = 2,CBS = 2 )

ggarrange(visGroupA2C_2+removeX , visGroupA2C0+theme_void(),visGroupA2C2+theme_void(), 
          visGroupA0C_2+removeX, visGroupA0C0+theme_void(), visGroupA0C2+theme_void(),
          visGroupA2C_2, visGroupA2C0+removeY, visGroupA2C2+removeY, ncol =3, nrow = 3)



#now contrast



model <- FinalHMC

IC <- 5 
ADS = 0
CBS = seq(-3,3,by  = 0.1)

visContrastsCBS <- function(model = FinalHMC, ADS = ADS , IC =  5, CBS = seq(-3,3,by  = 0.1))
  {
  groupID <- 1:3
  data <- expand.grid(ADS, groupID, IC , CBS)
  colnames(data) <- c("ADS", "groupID", "IC", "CBS")
  posterior <- extract.samples(model, n = 1e5)
  link( model, data=data ) 
  mu <- link( model, data=data ) 
  means <-  round(apply(mu , 2 , mean ), 4)
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrast <- cbind(data,means,t(as.data.frame(HPDIs)))
  
  ones <- 3 * (1:(nrow(visContrast)/3))-2
  twos <- 3 * (1:(nrow(visContrast)/3))-1
  threes <- 3 * (1:(nrow(visContrast)/3))
  
  colnames(visContrast)[c(6,7)] <- c("low", "high")
  contrast <- numeric(nrow(visContrast))
  cLow <- numeric(nrow(visContrast))
  cHigh <- numeric(nrow(visContrast))
  for(i in threes){
  contrast[i] <- visContrast$means[i] - visContrast$means[i-2]  
  }
  for(i in twos){
  contrast[i] <- visContrast$means[i] - visContrast$means[i-1]  
  }
  visContrast$contrast <- contrast
  visContrast$shift <-  visContrast$contrast - visContrast$means
  for(i in ones){
  visContrast$shift[i] <- 0
  }
  visContrast$cLow <- visContrast$low + visContrast$shift
  visContrast$cHigh <- visContrast$high + visContrast$shift

  visContrast$group = rep(c("control", "empathy", "normative"), nrow(visContrast)/3)

  visContrastTreatment <- visContrast[groupID !=1,]

  return(ggplot(visContrastTreatment, aes(x = CBS, y = contrast, color = group ))+ geom_pointrange(mapping = aes(ymin = cLow, ymax = cHigh), size = .2, alpha = .5) +theme_tufte())
}



visContrastCBSJoint <- ggarrange(visContrastsCBS(FinalHMC,ADS = -2)+ggtitle("ADS=-2")+ylim(c(-2.5,2.5))+ scale_color_discrete(guide=FALSE),
          visContrastsCBS(FinalHMC,ADS = 0)+ggtitle("ADS=0")+ylim(c(-2.5,2.5))+ scale_color_discrete(guide=FALSE),
          visContrastsCBS(FinalHMC,ADS = 2)+ggtitle("ADS=2")+ylim(c(-2.5,2.5))+
            theme(legend.position = c(0.75, 0.1)), ncol = 3)

visContrastCBSJoint2 <- annotate_figure(visContrastCBSJoint, 
                top = text_grob("(range restricted to (-2.5,2.5), IC at the rounded mean = 5)",
                                size = 10))
visContrastCBSJoint3 <- annotate_figure(visContrastCBSJoint2, 
                                  top = text_grob("Predicted distance from the control group mean vs. CBS  (standardized)",
                                                  size = 12))


visContrastCBSJoint3




visContrastsADS <- function(model = FinalHMC, CBS = CBS , IC =  5, ADS = seq(-3,3,by  = 0.1))
{
  data <- expand.grid(CBS, groupID, IC , ADS)
  colnames(data) <- c("CBS", "groupID", "IC", "ADS")
  posterior <- extract.samples(model, n = 1e5)
  mu <- link( model, data=data ) 
  means <-  round(apply(mu , 2 , mean ), 4)
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrastADS <- cbind(data,means,t(as.data.frame(HPDIs)))


  ones <- 3 * (1:(nrow(visContrastADS)/3))-2
  twos <- 3 * (1:(nrow(visContrastADS)/3))-1
  threes <- 3 * (1:(nrow(visContrastADS)/3))
  
  colnames(visContrastADS)[c(6,7)] <- c("low", "high")
  contrastADS <- numeric(nrow(visContrastADS))
  for(i in threes){
    contrastADS[i] <- visContrastADS$means[i] - visContrastADS$means[i-2]  
  }
  for(i in twos){
    contrastADS[i] <- visContrastADS$means[i] - visContrastADS$means[i-1]  
  }
  visContrastADS$contrast <- contrastADS
  visContrastADS$shift <-  visContrastADS$contrast - visContrastADS$means
  for(i in ones){
    visContrastADS$shift[i] <- 0
  }
  visContrastADS$cLow <- visContrastADS$low + visContrastADS$shift
  visContrastADS$cHigh <- visContrastADS$high + visContrastADS$shift
  
  visContrastADS$group = rep(c("control", "empathy", "normative"), nrow(visContrastADS)/3)
  visContrastTreatmentADS <- visContrastADS[groupID !=1,]

  return(ggplot(visContrastTreatmentADS, aes(x = ADS, y = contrast, color = group ))+ geom_pointrange(mapping = aes(ymin = cLow, ymax = cHigh), size = .2, alpha = .5) +theme_tufte())
}








visContrastADSJoint <- ggarrange(visContrastsADS(FinalHMC,CBS = -2)+ggtitle("ADS=-2")+ylim(c(-2.5,2.5))+ scale_color_discrete(guide=FALSE),
                                 visContrastsADS(FinalHMC,CBS = 0)+ggtitle("ADS=0")+ylim(c(-2.5,2.5))+ scale_color_discrete(guide=FALSE),
                                 visContrastsADS(FinalHMC,CBS = 2)+ggtitle("ADS=2")+ylim(c(-2.5,2.5))+
                                   theme(legend.position = c(0.75, 0.1)), ncol = 3)

visContrastADSJoint2 <- annotate_figure(visContrastADSJoint, 
                                        top = text_grob("(range restricted to (-2.5,2.5), IC at the rounded mean = 5)",
                                                        size = 10))
visContrastADSJoint3 <- annotate_figure(visContrastADSJoint2, 
                                        top = text_grob("Predicted distance from the control group mean vs. ADS (standardized)",
                                                        size = 12))


visContrastADSJoint3






#NOW IC


ADS <- 0
CBS <- 0
IC <-  seq(0,40,by = 1)
model <- FinalHMC


visContrastsIC <- function(model = FinalHMC, CBS = CBS , IC =  seq(0,30,by = 1), ADS = ADS)
{
  groupID <- 1:3
  data <- expand.grid(CBS, groupID, IC , ADS)
  data
  colnames(data) <- c("CBS", "groupID", "IC", "ADS")
  posterior <- extract.samples(model, n = 1e5)
  mu <- link( model, data=data ) 
  means <-  round(apply(mu , 2 , mean ), 4)
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrastIC <- cbind(data,means,t(as.data.frame(HPDIs)))
  
  ones <- 3 * (1:(nrow(visContrastIC)/3))-2
  twos <- 3 * (1:(nrow(visContrastIC)/3))-1
  threes <- 3 * (1:(nrow(visContrastIC)/3))
  
  colnames(visContrastIC)[c(6,7)] <- c("low", "high")
  contrastIC <- numeric(nrow(visContrastIC))
  for(i in threes){
    contrastIC[i] <- visContrastIC$means[i] - visContrastIC$means[i-2]  
  }
  for(i in twos){
    contrastIC[i] <- visContrastIC$means[i] - visContrastIC$means[i-1]  
  }
  visContrastIC$contrast <- contrastIC
  visContrastIC$shift <-  visContrastIC$contrast - visContrastIC$means
  for(i in ones){
    visContrastIC$shift[i] <- 0
  }
  visContrastIC$cLow <- visContrastIC$low + visContrastIC$shift
  visContrastIC$cHigh <- visContrastIC$high + visContrastIC$shift
  
  visContrastIC$group = rep(c("control", "empathy", "normative"), nrow(visContrastIC)/3)
  visContrastTreatmentIC <- visContrastIC[groupID !=1,]
  
  return(ggplot(visContrastTreatmentIC, aes(x = IC, y = contrast, color = group ))+ geom_pointrange(mapping = aes(ymin = cLow, ymax = cHigh), size = .2, alpha = .5)+ylim(c(-2,2)) +theme_tufte())
}


visContrastsICJoint <- ggarrange(
visContrastsIC(ADS = 2, CBS = -2)+removeX+ scale_color_discrete(guide=FALSE)+ggtitle("CBS = -2")+ylab("ADS = 2"),
    visContrastsIC(ADS = 2, CBS = 0)+removeY+removeX+ scale_color_discrete(guide=FALSE)+ggtitle("CBS = 0"),
    visContrastsIC(ADS = 2, CBS = 2)+removeY+removeX+ggtitle("CBS = 2"),
visContrastsIC(ADS = 0, CBS = -2)+removeX+ scale_color_discrete(guide=FALSE)+ylab("ADS = 0"),
    visContrastsIC(ADS = 0, CBS = 0)+removeY+removeX+ scale_color_discrete(guide=FALSE),
    visContrastsIC(ADS = 0, CBS = 2)+removeY+removeX,  
visContrastsIC(ADS = -2, CBS = -2)+ scale_color_discrete(guide=FALSE)+ylab("ADS = -2"),
    visContrastsIC(ADS = -2, CBS = 0)+removeY+ scale_color_discrete(guide=FALSE),
    visContrastsIC(ADS = -2, CBS = 0)+removeY, 
ncol = 3, nrow = 3
)




visContrastsICJoint2 <- annotate_figure(visContrastsICJoint, 
                                        top = text_grob("(range restricted to (-3,3))",
                                                        size = 10))
visContrastsICJoint3 <- annotate_figure(visContrastsICJoint2, 
                                        top = text_grob("Predicted distance from the control group mean vs. IC (standardized)",
                                                        size = 12))


visContrastsICJoint3










  muLong <- melt(mu)
  colnames(muLong) <- c("id", "group", "AdiffS")
  means <-  round(apply(mu , 2 , mean ), 2)
  mu_HPDI <- round(apply( mu , 2 , HPDI ),2)
  means <- as.data.frame(means)
  means$group <- rownames(means)
  rownames(means) <- NULL
  meansDisp <- cbind(means,t(as.data.frame(mu_HPDI)))
  meansDisp <- meansDisp[,c(1,3,4)]
  







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







