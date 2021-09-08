source("utils/plotPriors.R")

summaries <- readRDS(file = "datasets/Summaries.rds")



summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)
summaries$groupID <-  as.integer( as.factor(summaries$group) )

summaries$ApropS <- standardize(summaries$AA/summaries$AB)


ggplot(summaries)+geom_histogram(aes(x=ApropS, fill = group), bins = 100)


head(summaries)



nullModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu ~ dnorm (0,0.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries  
)


precis(nullModelProps)

#ADS
ADSModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,0.2),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSModelProps)


compare(nullModelProps,ADSModelProps)




ADSICModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu <-  a + bADS * ADS+ bIC * IC,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,0.2),
    bIC ~ dnorm(0,0.2),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)


compare(ADSModelProps,ADSICModelProps)

precis(ADSICModelProps)



ITModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu <-  bIT[groupID] ,
    bIT[groupID] ~ dnorm(0,1),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ITModelProps, depth = 2)

compare(ADSModelProps, ITModelProps)


ADSITModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID],
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSITModelProps, depth = 2)

compare(ADSModelProps,ADSITModelProps, ADSICModelProps)



ADSITICModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
    mu <- a + bADS * ADS +  bIT[groupID] + bIC * IC,
    a ~ dnorm (0,0.5),
    bADS ~ dnorm(0,.5),
    bIT[groupID] ~ dnorm(0,.5),
    bIC ~ dnorm(0,.5),
    sigma  ~ dexp(1)
  ), 
  data = summaries
)

precis(ADSITICModelProps, depth = 2)

compare(ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps)



ADSITICIntCountsModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
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


precis(ADSITICIntCountsModelProps, depth = 2)

compare(ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)



ADSITITIntCountsModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
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

precis(ADSITITIntCountsModelProps, depth = 2)

compare(ADSITITIntCountsModelProps,ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)




ADSITIntCountsModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
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



precis(ADSITIntCountsModelProps, depth = 2)

compare(ADSITIntCountsModelProps,ADSITITIntCountsModelProps,ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)



LotsOfInteractionsModelProps <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
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



precis(LotsOfInteractionsModelProps, depth = 2)

compare(LotsOfInteractionsModelProps,ADSITIntCountsModelProps,ADSITITIntCountsModelProps,ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)



#
LotsOfInteractionsModel2Props <- quap(
  alist(
    ApropS ~ dnorm( mu, sigma ),
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



precis(LotsOfInteractionsModel2Props, depth = 2)

compare(LotsOfInteractionsModel2Props,LotsOfInteractionsModelProps,ADSITIntCountsModelProps,ADSITITIntCountsModelProps,ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)



LotsOfInteractionsModel3Props <- quap(
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





precis(LotsOfInteractionsModel3Props, depth = 2)

compare(LotsOfInteractionsModel3Props,LotsOfInteractionsModel2Props,LotsOfInteractionsModelProps,ADSITIntCountsModelProps,ADSITITIntCountsModelProps,ADSITICModelProps,ADSModelProps, ADSITModelProps, ADSICModelProps,ADSITICIntCountsModelProps)


