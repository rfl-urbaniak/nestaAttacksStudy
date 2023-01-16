library(rethinking)
library(ggplot2)


playmusic <- browseURL('https://www.youtube.com/watch?v=Lx1iH8DgrLE&list=RDLx1iH8DgrLE&start_radio=1')



#volunteersSeparate <- readRDS("datasets/volunteersSeparate.rds")


#mean(apply(volunteersJoint,2, function(x) is.na(x)))


dat <- readRDS("datasets/volunteerDat.rds")

str(dat)



start.time <- Sys.time()
competitionModel <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + enth[volunteerID] * daysOfProject +
    comp[volunteerID] * competition,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
    compbar ~ dnorm(0, .3),
    compsigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.0001, upper = 5",
    l = "lower = 0.0001, upper = 5",
    lbar = "lower = 0.1, upper = 5",
    lsigmabar = "lower =  0.0001, upper = 5",
    enth = "lower = -1.5, upper = 5",
    enthbar = "lower = -1.5, upper = 5",
    enthsigmabar = "lower = 0.0001, upper = 5",
    comp = "lower = -1.5, upper = 5",
    compbar = "lower = -1.5, upper = 5",
    compsigmabar = "lower = 0.0001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic


saveRDS(competitionModel, "competitionModel.rds")


precis(competitionModel, depth  = 2)


#quadratic drop with time

exp(-0.26)


start.time <- Sys.time()
competitionQuadraticDropModel <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + enth[volunteerID] * daysOfProjectSquared +
      comp[volunteerID] * competition,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
    compbar ~ dnorm(0, .3),
    compsigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.0001, upper = 5",
    l = "lower = 0.0001, upper = 5",
    lbar = "lower = 0.1, upper = 5",
    lsigmabar = "lower =  0.0001, upper = 5",
    enth = "lower = -.3, upper = .2",
    enthbar = "lower = -.3, upper = .2",
    enthsigmabar = "lower = 0.0001, upper = .2",
    comp = "lower = -1, upper = 3",
    compbar = "lower = -1, upper = 3",
    compsigmabar = "lower = 0.0001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic


str(dat)

start.time <- Sys.time()
competitionInverseDropModel <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + enth[volunteerID] * daysOfProjectInverse +
      comp[volunteerID] * competition,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
    compbar ~ dnorm(0, .3),
    compsigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.0001, upper = 5",
    l = "lower = 0.0001, upper = 5",
    lbar = "lower = 0.1, upper = 5",
    lsigmabar = "lower =  0.0001, upper = 5",
    enth = "lower = -.8, upper = .3",
    enthbar = "lower = -.8, upper = .3",
    enthsigmabar = "lower = 0.0001, upper = .3",
    comp = "lower = -1.5, upper = 5",
    compbar = "lower = -1.5, upper = 5",
    compsigmabar = "lower = 0.0001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic



precis(competitionQuadraticDropModel, depth = 2)

precis(competitionInverseDropModel, depth = 2)


precis(competitionDropModel, depth = 2)

exp(.72)

exp(-0.23)

exp(.3)

saveRDS(competitionQuadraticDropModel, "competitionQuadraticDropModel.rds")

competitionModel <- readRDS("competitionModel.rds")

compare(competitionQuadraticDropModel,competitionModel,competitionInverseDropModel)

precis(competitionQuadraticDropModel, depth = 2)

exp(.1)

exp(-0.37)



exp(.31)

#dat$daysFromAnnouncement

start.time <- Sys.time()
competitionDfaModel <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1 + 
#      comp[volunteerID] * competition+
      dfa[volunteerID] * daysFromAnnouncement,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5),
#    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
#    compbar ~ dnorm(0, .3),
#    compsigmabar ~ dexp(.5),
    dfa[volunteerID] ~ dnorm(dfabar, dfasigmabar),
    dfabar ~ dnorm(0, .3),
    dfasigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 7000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5",
    comp = "lower = 0.00001, upper = 5",
    compbar = "lower = 0.00001, upper = 5",
    compsigmabar = "lower = 0.00001, upper = 5",
    dfa = "lower = 0.00001, upper = 5",
    dfabar = "lower = 0.00001, upper = 5",
    dfasigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #     cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
browseURL('https://www.youtube.com/watch?v=Lx1iH8DgrLE&list=RDLx1iH8DgrLE&start_radio=1')


compare(nullNbinAR1Hierarchical,competitionModel,competitionDfaModel)

#dfa is not worth it; try  days to deadline are correlated, try days after deadline



str(dat)


#dat$daysAfterDeadline

start.time <- Sys.time()
competitionDadModel <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] +    #a[volunteerID] * interventionsL1 + 
      comp[volunteerID] * competition+
      dad[volunteerID] * daysAfterDeadline,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
  #  a[volunteerID] ~ dnorm(abar, asigmabar),
  #  abar ~ dnorm(0, .3),
  #  asigmabar ~ dexp(.5),
    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
    compbar ~ dnorm(0, .3),
    compsigmabar ~ dexp(.5),
    dad[volunteerID] ~ dnorm(dadbar, dadsigmabar),
    dadbar ~ dnorm(0, .3),
    dadsigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 7000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5",
    comp = "lower = 0.00001, upper = 5",
    compbar = "lower = 0.00001, upper = 5",
    compsigmabar = "lower = 0.00001, upper = 5",
    dtd = "lower = 0.00001, upper = 5",
    dtdbar = "lower = 0.00001, upper = 5",
    dtdsigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #     cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
browseURL('https://www.youtube.com/watch?v=Lx1iH8DgrLE&list=RDLx1iH8DgrLE&start_radio=1')


compare(nullNbinAR1Hierarchical,competitionModel,competitionDfaModel, competitionDadModel)


#so we're sticking with competition model

prec <- as.data.frame(precis(competitionModel, depth = 2))

precComp <- prec[grep("comp",rownames(prec)),]

ggplot(data = precComp) +geom_point(aes(x = rownames(precComp), y = exp(mean)) )+
  coord_flip()+ylim(0,5)



prec

exp(-.36)





start.time <- Sys.time()
competitionDoPAR1Model <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1 + 
      comp[volunteerID] * competition + enth[volunteerID] * daysOfProject,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5),
    comp[volunteerID] ~ dnorm(compbar, compsigmabar),
    compbar ~ dnorm(0, .3),
    compsigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 7000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5",
    comp = "lower = 0.00001, upper = 5",
    compbar = "lower = 0.00001, upper = 5",
    compsigmabar = "lower = 0.00001, upper = 5",
    enth = "lower = 0.00001, upper = 5",
    enthbar = "lower = 0.00001, upper = 5",
    enthsigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #     cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
browseURL('https://www.youtube.com/watch?v=Lx1iH8DgrLE&list=RDLx1iH8DgrLE&start_radio=1')





