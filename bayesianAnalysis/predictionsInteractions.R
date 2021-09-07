source("utils/plotPriors.R")

summaries <- readRDS(file = "datasets/Summaries.rds")



summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)
summaries$groupID <-  as.integer( as.factor(summaries$group) )



LotsOfInteractionsModel3 <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bCBS[groupID] ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



head(summaries)





mean(summaries$IC[summaries$groupID != 1])

ADS <- seq(-2,-1, by = 0.1)
CBS <- seq(-2,-1, by = 0.1)
groupID <- 1:3
IC <- 5  #mean for interventions in treatment
data <- expand.grid(ADS = ADS,groupID = groupID, CBS = CBS, IC =  IC)

predictions <-  link(LotsOfInteractionsModel3,data = data)
predictions.mean <- apply( predictions , 2 , mean )
predictionsDF <- cbind(data,predictions.mean)
predictionsDF
ggplot(predictionsDF)+geom_point(aes(x = groupID, y = predictions.mean))


ADS <- seq(-2,2, by = 0.1) 
groupID <- 2
IC <- 1
data <- expand.grid(ADS = ADS,groupID = groupID,IC =  IC)

predictions <-  link(LotsOfInteractionsModel,data = data)
predictions.mean <- apply( predictions , 2 , mean )
predictionsDF <- cbind(data,predictions.mean)
predictionsPlotg2i1 <- ggplot(predictionsDF)+geom_line(aes(x = ADS, y = predictions.mean))+theme_tufte()+ggtitle("Group = 2, IC = 1")



ADS <- 0
groupID <- 2
IC <- 1:15
data <- expand.grid(ADS = ADS,groupID = groupID,IC =  IC)
data
predictions <-  link(LotsOfInteractionsModel,data = data)
predictions.mean <- apply( predictions , 2 , mean )
predictionsDF <- cbind(data,predictions.mean)
predictionsPlotg2ads0 <- ggplot(predictionsDF)+geom_line(aes(x = IC, y = predictions.mean))+theme_tufte()+ggtitle("Group = 2, ADS = 0")

predictionsPlotg2ads0


ADS <- 2
groupID <- 3
IC <- 1:15
data <- expand.grid(ADS = ADS,groupID = groupID,IC =  IC)
data
predictions <-  link(LotsOfInteractionsModel,data = data)
predictions.mean <- apply( predictions , 2 , mean )
predictionsDF <- cbind(data,predictions.mean)
predictionsPlotg3ads0 <- ggplot(predictionsDF)+geom_line(aes(x = IC, y = predictions.mean))+theme_tufte()+ggtitle("Group = 3, ADS = 0")

predictionsPlotg3ads0



