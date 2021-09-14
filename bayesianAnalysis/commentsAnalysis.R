library(ggplot2)
library(ggthemes)
library(gridExtra)
library(kableExtra)
library(viridis)
library(rethinking)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(GGally)
library(dagitty)
library(reshape)



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


head(summaries)


cNull <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu ~ dnorm (0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries  
)


cADS <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cADSIC <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS+ bIC * IC,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,0.3),
    bIC ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cIT <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <-  bIT[groupID] ,
    bIT[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

cADSIT <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID],
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cADSITIC <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



cADSITIC_ADSIC <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cADSITIC_ADSIC_ADSIT <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cADSIT_ADSIT <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] ,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    #bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.3),
    #bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



cADSITIC_ADSIT_ITIC_ADSIC <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC +
      bADSIC * ADS * IC,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



cADSITICABS_ITIC_ADSIC <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bABS *ABS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bABS ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


cFinal <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bABS[groupID] *ABS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bABS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)






cTooFar <- quap(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bABS[groupID] *ABS + bABSIC * ABS * IC, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bABS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bABSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


Ccomparison<- compare(cNull,cADS,cADSIC,cIT,cADSIT,cADSITIC,cADSITIC_ADSIC,
                     cADSITIC_ADSIC_ADSIT,cADSIT_ADSIT,cADSITIC_ADSIT_ITIC_ADSIC,
                     cADSITICABS_ITIC_ADSIC, cFinal, cTooFar)

Ccomparison

plot(Ccomparison)


cTooFarHMC <- ulam(
  alist(
    CdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bABS[groupID] *ABS + bABSIC * ABS * IC, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bABS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bABSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

saveRDS(cTooFarHMC, file = "models/cTooFarHMC.rds")
cTooFarHMC <- readRDS(file = "models/cTooFarHMC.rds")



precis(cTooFarHMC, depth = 2)
plot(precis(cTooFarHMC, depth = 2))


ADS <- 0
ABS <- 0
model <- cTooFarHMC


#now visualise by groups
CvisGroup <- function (model, ADS, ABS)
{
  groupID <- 1:3
  IC <- 5 
  data <- expand.grid(ADS = ADS,groupID = groupID, ABS = ABS, IC =  IC)
  posterior <- extract.samples(model, n = 1e5)
  mu <- link( model, data=data ) 
  colnames(mu) <- levels(summaries$group)
  muLong <- melt(mu)
  colnames(muLong) <- c("id", "group", "CdiffS")
  means <-  round(apply(mu , 2 , mean ), 2)
  mu_HPDI <- round(apply( mu , 2 , HPDI ),2)
  means <- as.data.frame(means)
  means$group <- rownames(means)
  rownames(means) <- NULL
  meansDisp <- cbind(means,t(as.data.frame(mu_HPDI)))
  meansDisp <- meansDisp[,c(1,3,4)]
  
  plot <- ggplot(muLong)+geom_violin(aes(x = group, y = CdiffS), alpha = 0.2)+
    xlab("")+
    labs(title = paste("ADS=", ADS, ", ABS=",  ABS,  sep = ""))+
    theme_tufte()+ylim(c(-4,4))
  #+   annotation_custom(tableGrob(meansDisp), xmin=xmin,  ymax=ymax)
  return(plot)
}



cvisGroupA2B_2 <- CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = -2)
cvisGroupA2B0 <- CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = 0 )
cvisGroupA2B2 <- CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = 2)

cvisGroupA0B_2 <- CvisGroup(model =  cTooFarHMC, ADS = 0,ABS = -2 )
cvisGroupA0B0 <- CvisGroup(model =  cTooFarHMC, ADS = 0,ABS = 0 )
cvisGroupA0B2 <-  CvisGroup(model =  cTooFarHMC, ADS = 0,ABS = 2)

cvisGroupA2B_2 <-  CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = -2 )
cvisGroupA2B0 <- CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = 0 )
cvisGroupA2B2 <- CvisGroup(model =  cTooFarHMC, ADS = 2,ABS = 2 )

cvisGroupJoint <- ggarrange(cvisGroupA2B_2+removeX + ggtitle("ABS = -2")+ylab("ADS = 2") , cvisGroupA2B0+theme_void()+ ggtitle("ABS = 0"), cvisGroupA2B2+theme_void()+ ggtitle("ABS = 2"), 
                           cvisGroupA0B_2+removeX+ylab("ADS = 0")+ggtitle(""), cvisGroupA0B0+theme_void()+ggtitle(""), cvisGroupA0B2+theme_void()+ggtitle(""),
                           cvisGroupA2B_2+ylab("ADS = -2")+ggtitle(""), cvisGroupA2B0+removeY+ggtitle(""), cvisGroupA2B2+removeY+ggtitle(""), ncol =3, nrow = 3)


cvisGroupJoint2 <- annotate_figure(cvisGroupJoint, 
                                  top = text_grob("(range restricted to (-4,4), IC at the rounded mean = 5)",
                                                  size = 10))
cvisGroupJoint3 <- annotate_figure(cvisGroupJoint2, 
                                  top = text_grob("Predicted change in comments by ADS, ABS, and treatment groups (standardized)",
                                                  size = 12))

cvisGroupJoint3 




