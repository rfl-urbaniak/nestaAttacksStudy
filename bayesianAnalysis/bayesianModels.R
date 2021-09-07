source("utils/plotPriors.R")


summaries <- readRDS(file = "datasets/Summaries.rds")
head(summaries)

precis(summaries)

summaries$ABw <- (summaries$AB/81)*7
summaries$CBw <- (summaries$CB/81)*7
summaries$AAw <- (summaries$AB/72)*7
summaries$CAw <- (summaries$CB/72)*7
summaries$ADw <- (summaries$AD/62)*7
summaries$CDw <- (summaries$CD/62)*7
summaries$Adiffw <- summaries$AAw - summaries$ABw
summaries$Cdiffw <- summaries$CAw - summaries$CBw


summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)

summary(summaries$AAS)

#null model: AA


#prior plot
set.seed(2971)
N <- 300
mu <- rnorm(N, 0, 0.5) 
ggplot()+geom_density(aes(x = mu))+theme_tufte()

ggplot()+geom_density(aes(x = mu))


nullModel <- quap(
          alist(
          AAS ~ dnorm( mu, sigma ),
          mu ~ dnorm (0,0.5),
          sigma  ~ dexp(1)
          ), 
          data = summaries  
          )




precis(nullModel)

postNullModel <- extract.samples(nullModel, n = 1e4 )

precis(postNullModel)



#only ADS 
ADSModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,0.2),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSModel)


compare(nullModel,ADSModel)

# priors for ADS model
visualisePriors(ADSModel, list(ADS = c(-3,3)))

#posteriors for ADS model
g <- ggplot()+geom_point(aes(x=x,y=y), alpha = 0.2)+theme_tufte()  
post <- extract.samples( ADSModel)
a_map <- mean(post$a)
bADS_map <- mean(post$bADS)
lines <- function (x) {a_map + bADS_map * x} 
#g + geom_function(fun = lines)


#ADS with IC
ADSICModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS+ bIC * IC,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,0.2),
    bIC ~ dnorm(0,0.2),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

compare(ADSModel,ADSICModel)

precis(ADSICModel)

#posteriors for ADSIC
g <- ggplot()+geom_point(aes(x=x,y=y), alpha = 0.2)+theme_tufte()  
post <- extract.samples( ADSICModel)
head(post)
a_map <- mean(post$a)
bADS_map <- mean(post$bADS)
bIC_map <- mean(post$bIC)
line <- function (x) {a_map + bADS_map * x + bIC_map *x} 
g + geom_function(fun = line)

#1: control, 2: empathy, 3: normative



summaries$groupID <-  as.integer( as.factor(summaries$group) )



#IT model
ITModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <-  bIT[groupID] ,
    bIT[groupID] ~ dnorm(0,1),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ITModel, depth = 2)

compare(ADSModel, ITModel)


#ADSIT model
ADSITModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID],
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSITModel, depth = 2)

compare(ADSModel,ADSITModel, ADSICModel)




#ADSITIC model
ADSITICModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSITICModel, depth = 2)

compare(ADSITICModel,ADSModel, ADSITModel, ADSICModel)


#ADSITICInteractionWithCounts model
ADSITICIntCountsModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


compare(ADSITICModel,ADSModel, ADSITModel, ADSICModel,ADSITICIntCountsModel)


precis(ADSITICIntCountsModel, depth = 2)




#ADSITITInteractionWithType model
ADSITITIntCountsModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC * IC + bADSIC * ADS * IC,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


compare(ADSITICModel,ADSModel, ADSITModel, ADSICModel,ADSITICIntCountsModel,ADSITITIntCountsModel)


precis(ADSITITIntCountsModel, depth = 2)



#ADSInteractionWithType model
ADSITIntCountsModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] ,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    #bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    #bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



compare(ADSITIntCountsModel,ADSITICModel,ADSModel, ADSITModel, ADSICModel,ADSITICIntCountsModel,ADSITITIntCountsModel)


#note, this is worse than the previous one

#+ bIC * IC + bADSIC * ADS * IC



#LotsOfInteractions model
LotsOfInteractionsModel <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


compare(ADSITIntCountsModel,ADSITICModel,ADSModel, ADSITModel, ADSICModel,ADSITICIntCountsModel,ADSITITIntCountsModel,LotsOfInteractionsModel)


#this one does much better!


precis(LotsOfInteractionsModel, depth = 2)

#let's take a closer look
# plot predictions for various setups









predictionsDF <-  as.data.frame(t(link(LotsOfInteractionsModel,data = data)))

str(predictionsDF)

predictionsDataDF <- cbind(data, predictionsDF)


str(predictionsDataDF)  

mut
  
visualisePriors <- function(model, dataAsList, N = 100)
{
  prior <- extract.prior( model, n = N )
  mu <- link( model , post=prior, data=dataAsList)  
  mut <- as.data.frame(t(mu))
  mutLong <- melt(mut)
  mutLong$x <- rep(c(-3,3),N)
  ggplot(mutLong)+geom_line(aes(x = x, y = value, group = variable), alpha = 0.2)+theme_tufte()+xlab(names(data)[1])
}








#
LotsOfInteractionsModel2 <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS *CBS,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bCBS ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

head(summaries)
#AND THE WINNER IS...!
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




compare(LotsOfInteractionsModel, LotsOfInteractionsModel2, LotsOfInteractionsModel3)


















LotsOfInteractionsModel4 <- quap(
  alist(
    AAS ~ dnorm( mu, sigma ),
    mu <- a + bADS[groupID] * ADS +  bIT[groupID] + bIC[groupID] * IC + bADSIC * ADS * IC+ bCBS[groupID] *CBS + bCBIC * CBS * IC,
    a ~ dnorm (0,0.5),
    bADS[groupID] ~ dnorm(0,.5),
    bADSIC ~ dnorm(0,.5),
    bCBIC~ dnorm(0,.5),
    bCBS[groupID] ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)



compare(LotsOfInteractionsModel, LotsOfInteractionsModel2, LotsOfInteractionsModel3, LotsOfInteractionsModel4)




LotsOfInteractionsModel3Adiff <- quap(
  alist(
    AdiffS ~ dnorm( mu, sigma ),
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


