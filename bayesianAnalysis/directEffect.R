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

nullDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bCAS * CAS,
    a ~ dnorm (0,0.3),
    bCAS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries  
)

ADSDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,0.3),
    bCAS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

ADSICDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS+ bIC * IC+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,0.3),
    bIC ~ dnorm(0,0.3),
    bCAS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ITDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <-  bIT[groupID] + bCAS * CAS,
    bIT[groupID] ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID]+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bIT[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITICDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITIC_ADSICDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bADSIC ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITIC_ADSIC_ADSITDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC+ bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSIT_ADSITDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    #bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.3),
    #bIC ~ dnorm(0,.5),
    bCAS ~ dnorm(0,0.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITIC_ADSIT_ITIC_ADSICDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC +
      bADSIC * ADS * IC + bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


ADSITICCBS_ITIC_ADSICDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS *CBS + bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCBS ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


FinalDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCAS * CAS,
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



tooFarDirect <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBSIC * CBS * IC + bCAS * CAS, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bCBSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)




tooFarDirect_CASIT <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBSIC * CBS * IC + bCAS[groupID] * CAS, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS[groupID] ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bCBSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



tooFarDirect_CASIC <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBSIC * CBS * IC + bCAS * CAS + bCASIC * CAS * IC, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bCASIC ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bCBSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


tooFarDirect_CASIC_CASIT <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBSIC * CBS * IC + bCAS[groupID] * CAS + bCASIC * CAS * IC, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS[groupID] ~ dnorm(0,0.3),
    bCASIC ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bCBSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)








comparisonDirect<- compare(nullDirect,ADSDirect,ADSICDirect,ITDirect,ADSITDirect,ADSITICDirect,ADSITIC_ADSICDirect, ADSITIC_ADSIC_ADSITDirect,ADSIT_ADSITDirect,ADSITIC_ADSIT_ITIC_ADSICDirect,
                     ADSITICCBS_ITIC_ADSICDirect,FinalDirect, tooFarDirect,tooFarDirect_CASIT,
                     tooFarDirect_CASIC,tooFarDirect_CASIC_CASIT)


comparisonDirect



plot(comparisonDirect)




#now build HMC model


tooFarDirectHMC <- ulam(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + 
      bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBSIC * CBS * IC + bCAS * CAS, 
    a ~ dnorm (0,0.3),
    bADS[groupID] ~ dnorm(0,.3),
    bADSIC ~ dnorm(0,.3),
    bCAS ~ dnorm(0,0.3),
    bCBS[groupID] ~ dnorm(0,.3),
    bIT[groupID] ~ dnorm(0,.3),
    bIC[groupID] ~ dnorm(0,.3),
    bCBSIC ~ dnorm(0, .3),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


saveRDS(tooFarDirectHMC, file = "models/tooFarDirectHMC.rds")
tooFarDirectHMC <- readRDS(file = "models/tooFarDirectHMC.rds")


plot(precis(tooFarDirectHMC, depth = 2))




visGroupDirect <- function (model, ADS, CBS, CAS, xmin =2, ymax = -3)
{
  groupID <- 1:3
  IC <- 5 
  data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, CAS = CAS, IC =  IC)
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
    labs(title = paste("ADS=", ADS, ", CBS=",  CBS, ", CAS=", CAS,  sep = ""))+
    theme_tufte()+ylim(c(-4,4))
  #+   annotation_custom(tableGrob(meansDisp), xmin=xmin,  ymax=ymax)
  return(plot)
}



visGroupDirect2_2_2 <-  visGroupDirect(model = tooFarDirectHMC, ADS = 2,CBS = -2, CAS = -2)
visGroupDirect200 <-  visGroupDirect(model = tooFarDirectHMC, ADS = 2,CBS = 0, CAS = 0)
visGroupDirect222 <- visGroupDirect(model = tooFarDirectHMC, ADS = 2,CBS = 2, CAS = 2)

visGroupDirect0_2_2 <-  visGroupDirect(model = tooFarDirectHMC, ADS = 0,CBS = -2, CAS = -2)
visGroupDirect000 <-  visGroupDirect(model = tooFarDirectHMC, ADS = 0,CBS = 0, CAS = 0)
visGroupDirect022 <- visGroupDirect(model = tooFarDirectHMC, ADS = 0,CBS = 2, CAS = 2)


visGroupDirect_2_2_2 <-  visGroupDirect(model = tooFarDirectHMC, ADS = -2,CBS = -2, CAS = -2)
visGroupDirect_200 <-  visGroupDirect(model = tooFarDirectHMC, ADS = -2,CBS = 0, CAS = 0)
visGroupDirect_222 <- visGroupDirect(model = tooFarDirectHMC, ADS = -2,CBS = 2, CAS = 2)


visGroupDirectJoint <- ggarrange(visGroupDirect2_2_2+removeX +ylab("ADS = 2")+ggtitle("CBS = CAS = -2"),
                                 visGroupDirect200+removeX+removeY+ ggtitle("CBS = CAS = 0"),
                                 visGroupDirect222+removeX+removeY+ ggtitle("CBS = CAS = 2") ,
                        visGroupDirect0_2_2+removeX + ggtitle("")+ylab("ADS = 0"),
                                visGroupDirect000+removeX+removeY+ ggtitle(""),
                                visGroupDirect022+removeX+removeY+ ggtitle(""),
                        visGroupDirect_2_2_2+removeX+ylab("ADS = -2")+ ggtitle(""),
                                  visGroupDirect_200+removeX+removeY+ ggtitle(""),
                        visGroupDirect_222+removeX+removeY+ ggtitle("")
                                 ,ncol =3, nrow = 3)
                                  
      


visGroupDirectJoint2 <- annotate_figure(visGroupDirectJoint, 
                                  top = text_grob("(range restricted to (-4,4), IC at the rounded mean = 5)",
                                                  size = 10))
visGroupJoint3 <- annotate_figure(visGroupDirectJoint2, 
                                  top = text_grob("Predicted direct effect of treatment group by activity profile (standardized)",
                                                  size = 12))

visGroupJoint3



#now contrasts, we dont plot against CAS, as this is neither easily manipulable nor learnable ahead of time

visContrastsCBSDirect <- function(model = FinalHMC, ADS = ADS , CAS= CAS, IC =  2,
                            CBS = seq(-3,3,by  = 0.1)){
  groupID <- 1:3
  data <- expand.grid(ADS, groupID, CAS, IC , CBS)
  colnames(data) <- c("ADS", "groupID", "CAS", "IC", "CBS")
  posterior <- extract.samples(model, n = 1e5)
  link( model, data=data ) 
  mu <- link( model, data=data ) 
  
  means <-  round(apply(mu , 2 , mean ), 4)
  
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrast <- cbind(data,means,t(as.data.frame(HPDIs)))
  
  ones <- 3 * (1:(nrow(visContrast)/3))-2
  twos <- 3 * (1:(nrow(visContrast)/3))-1
  threes <- 3 * (1:(nrow(visContrast)/3))
  
  colnames(visContrast)[c(7,8)] <- c("low", "high")
  
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
  
  visContrast$group = rep(c("control", "empathy", "normative"), 
                          nrow(visContrast)/3)
  
  visContrastTreatment <- visContrast[groupID !=1,]
  
  return(ggplot(visContrastTreatment, aes(x = CBS, y = contrast, fill = group ))+
           geom_line(se = FALSE)+
           geom_ribbon(mapping = 
                         aes(ymin = cLow, ymax = cHigh),  
                       alpha = .3)+
           theme_tufte()+ylim(c(-3.5,3.5)))
}

visContrastDirect <-  ggarrange(visContrastsCBSDirect(model = tooFarDirect,ADS = -2, CAS = -2, IC = 5)+ggtitle("ADS = CAS = -2")+ scale_fill_discrete(guide=FALSE),
          visContrastsCBSDirect(model = tooFarDirect,ADS = 0, CAS = 0, IC = 15) +ggtitle("ADS = CAS = 0")+ scale_fill_discrete(guide=FALSE)+removeY,
          visContrastsCBSDirect(model = tooFarDirect,ADS = 2, CAS = 2, IC = 15) +ggtitle("ADS = CAS = 2")+ scale_fill_discrete(guide=FALSE)+removeY
          ,ncol =3)

visContrastDirect
                                 

visContrastDirect2 <- annotate_figure(visContrastDirect, 
                                        top = text_grob("(range restricted to (-3.5,3.5), IC at the rounded mean = 5)",
                                                        size = 10))
visContrastDirect3 <- annotate_figure(visContrastDirect2, 
                                        top = text_grob("Predicted direct effect distance from the control group mean vs. CBS  (standardized)",
                                                        size = 12))

visContrastDirect3











visContrastsADSDirect <- function(model = FinalHMC, CBS = CBS , CAS = CAS, IC =  5, 
                            ADS = seq(-3,3,by  = 0.1))
{
  data <- expand.grid(CBS, groupID, CAS, IC , ADS)
  colnames(data) <- c("CBS", "groupID", "CAS", "IC", "ADS")
  posterior <- extract.samples(model, n = 1e5)
  mu <- link( model, data=data ) 
  means <-  round(apply(mu , 2 , mean ), 4)
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrastADS <- cbind(data,means,t(as.data.frame(HPDIs)))
  
  
  ones <- 3 * (1:(nrow(visContrastADS)/3))-2
  twos <- 3 * (1:(nrow(visContrastADS)/3))-1
  threes <- 3 * (1:(nrow(visContrastADS)/3))
  
  colnames(visContrastADS)[c(7,8)] <- c("low", "high")
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
  
  visContrastADS$group = rep(c("control", "empathy", "normative"), 
                             nrow(visContrastADS)/3)
  visContrastTreatmentADS <- visContrastADS[groupID !=1,]
  
  return(ggplot(visContrastTreatmentADS, aes(x = ADS, y = contrast, fill = group ))+
           geom_line(se = FALSE) +
           geom_ribbon(mapping = aes(ymin = cLow, ymax = cHigh), 
                       alpha = .3) +theme_tufte())
}





visContrastADSDirectJoint <- ggarrange(
  visContrastsADSDirect(tooFarDirect,CBS = -2, CAS = -2)+ggtitle("CBS = CAS = -2")+ylim(c(-3,3))+ scale_fill_discrete(guide=FALSE),
  visContrastsADSDirect(tooFarDirect, CBS = 0, CAS = 0)+ggtitle("CBS = CAS = 0")+ylim(c(-3,3))+ scale_fill_discrete(guide=FALSE),
  visContrastsADSDirect(tooFarDirect, CBS = 2, CAS = 2)+ggtitle("CBS = CAS = 2")+ylim(c(-3,3))+ scale_fill_discrete(guide=FALSE),
  ncol =3)
  

  
  
visContrastADSDirectJoint2 <- annotate_figure(visContrastADSDirectJoint, 
                                        top = text_grob("(range restricted to (-3,3), IC at the rounded mean = 5)",
                                                        size = 10))
visContrastADSDirectJoint3 <- annotate_figure(visContrastADSDirectJoint2, 
                                        top = text_grob("Predicted direct effect distance from the control group mean vs. ADS (standardized)",
                                                        size = 12))

visContrastADSDirectJoint3












visContrastsICDirect <- function(model = FinalHMC, CBS = CBS , CAS = CAS,
                           IC =  seq(0,20,by = 1), ADS = ADS)
{
  groupID <- 1:3
  data <- expand.grid(CBS, groupID, CAS, IC , ADS)
  data
  colnames(data) <- c("CBS", "groupID", "CAS", "IC", "ADS")
  posterior <- extract.samples(model, n = 1e5)
  mu <- link( model, data=data ) 
  means <-  round(apply(mu , 2 , mean ), 4)
  HPDIs <- round(apply( mu , 2 , HPDI ),4)
  visContrastIC <- cbind(data,means,t(as.data.frame(HPDIs)))
  
  ones <- 3 * (1:(nrow(visContrastIC)/3))-2
  twos <- 3 * (1:(nrow(visContrastIC)/3))-1
  threes <- 3 * (1:(nrow(visContrastIC)/3))
  
  colnames(visContrastIC)[c(7,8)] <- c("low", "high")
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
  
  visContrastIC$group = rep(c("control", "empathy", "normative"),
                            nrow(visContrastIC)/3)
  visContrastTreatmentIC <- visContrastIC[groupID !=1,]
  
  return(ggplot(visContrastTreatmentIC, aes(x = IC, y = contrast, fill = group ))+
           geom_line(se=FALSE)+
           geom_ribbon(mapping = aes(ymin = cLow, ymax = cHigh), alpha = .3)+
           ylim(c(-2,2)) +theme_tufte()+geom_hline(yintercept = 0, lty =2, size = 0.1))
}

visContrastsICDirect(model = tooFarDirect, ADS = 2, CBS = -2, CAS = -2)


visContrastsICJointDirect <- ggarrange(
  visContrastsICDirect(model = tooFarDirect, ADS = 2, CBS = -2, CAS = -2)+removeX+ 
    theme(legend.position = c(0.3, 0.9),
          legend.key.size = unit(.3, 'cm'),
          legend.key.height = unit(.3, 'cm'),
          legend.key.width = unit(.3, 'cm'),
          legend.title= element_blank())+
    ggtitle("CBS = CAS = -2")+
    ylab("ADS = 2"),
  visContrastsICDirect(model = tooFarDirect,ADS = 2, CBS = 0, CAS = 0)+removeY+removeX+ scale_fill_discrete(guide=FALSE)+
    ggtitle("CBS = CBS = 0"),
  visContrastsICDirect(model = tooFarDirect,ADS = 2, CBS = 2, CBS = 2)+removeY+removeX+ggtitle("CBS = CAS = 2")+ scale_fill_discrete(guide=FALSE),
  visContrastsICDirect(model = tooFarDirect,ADS = 0, CBS = -2, CAS = - 2)+removeX+ scale_fill_discrete(guide=FALSE)+
    ylab("ADS = 0"),
  visContrastsICDirect(model = tooFarDirect,ADS = 0, CBS = 0, CAS = 0)+removeY+removeX+ 
    scale_fill_discrete(guide=FALSE),
  visContrastsICDirect(model = tooFarDirect,ADS = 0, CBS = 2, CAS = 2)+removeY+removeX+ scale_fill_discrete(guide=FALSE),  
  visContrastsICDirect(model = tooFarDirect,ADS = -2, CBS = -2, CBS = -2)+ scale_fill_discrete(guide=FALSE)+
    ylab("ADS = -2"),
  visContrastsICDirect(model = tooFarDirect,ADS = -2, CBS = 0, CAS = 0)+removeY+ scale_fill_discrete(guide=FALSE),
  visContrastsICDirect(model = tooFarDirect,ADS = -2, CBS = 0, CAS = 0)+removeY+ scale_fill_discrete(guide=FALSE), 
  ncol = 3, nrow = 3
)

visContrastsICJointDirect2 <- annotate_figure(visContrastsICJointDirect, 
                                        top = text_grob("(range restricted to (-3,3))", 
                                                        size = 10))

visContrastsICJointDirect3 <- annotate_figure(visContrastsICJointDirect2, 
                                        top = text_grob("Predicted direct effect distance from the control group mean vs. IC (standardized)",
                                                        size = 12))

visContrastsICJointDirect3











