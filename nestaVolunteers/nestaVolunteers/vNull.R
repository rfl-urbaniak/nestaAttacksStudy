library(rethinking)
library(ggplot2)
library(data.table)
library(dplyr)


#playMusic <- browseURL('https://www.youtube.com/watch?v=Lx1iH8DgrLE&list=RDLx1iH8DgrLE&start_radio=1')



volunteersSeparate <- readRDS("datasets/volunteersSeparate.rds")
volunteersJoint <- rbindlist(volunteersSeparate, fill=FALSE, idcol=NULL)

mean(apply(volunteersJoint,2, function(x) is.na(x)))


dat <- readRDS("datasets/volunteerDat.rds")


str(dat)


nullPoisson <-  ulam(
  alist(
    interventions ~ dpois( lambda),
    log(lambda) <- l,
    l ~ dnorm(3,1.4)
  ), data=dat, log_lik = TRUE,
  constraints = list(
    l = "lower = 0, upper = 100"
  )
  )


prior <- extract.prior( nullPoisson , n=1e4 )
lambda <- exp(prior$l) 
priorPlot <- ggplot()+geom_density(aes(x = lambda))+xlim(c(0,80))+
  ggtitle("Lambda")+theme_tufte()

priorPlot


#null with volunteer-specific lambdas

nullPoissonVolunteer <-  ulam(
  alist(
    interventions ~ dpois( lambda),
    log(lambda) <- l[volunteerID],
    l[volunteerID] ~ dnorm(3,1.4)
  ), data=dat, log_lik = TRUE,
  constraints = list(
    l = "lower = 0, upper = 100"
  )
  )


nullPoissonHierarchical <-  ulam(
  alist(
    interventions ~ dpois( lambda),
    log(lambda) <- l[volunteerID],
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(3, .3),
    lsigmabar ~ dexp(.5)
  ), data=dat, log_lik = TRUE,
  constraints = list(
    l = "lower = 0, upper = 100",
    lbar = "lower = 0, upper = 100",
    lsigmabar = "lower = 0, upper = 100"
  )
)



prior <- extract.prior( nullPoissonHierarchical , n=1e4 )
lambda <- exp(prior$l) 
priorPlot <- ggplot()+geom_density(aes(x = lambda))+xlim(c(0,80))+
  ggtitle("Lambda")+theme_tufte()

priorPlot


compare(nullPoisson, nullPoissonVolunteer,nullPoissonHierarchical)


precis(nullPoissonHierarchical, depth = 2)


#ok now with AR1
#need to play with priors
rlbar <- rnorm(1000, 2, .9)
rlsigmabar <- rexp(1000, .5)
abar <- rnorm(1000, 0, .3)
asigmabar <- rexp(1000,.5)

rlv <- list()
rav <- list()
for (i in 1:1000){
  rlv[[i]] <- rnorm(100,rlbar[i],rlsigmabar[i])
  rav[[i]] <- rnorm(100,abar[i], asigmabar[i])
}
rlvJoint <- unlist(rlv)
ravJoint <- unlist(rav)
ggplot()+geom_density(aes(x=exp(rlbar)))+xlim(0,50)
ggplot()+geom_density(aes(x=exp(rlsigmabar)))+xlim(0,50)
ggplot()+geom_density(aes(x=exp(abar)))+xlim(0,2)
ggplot()+geom_density(aes(x=exp(rlvJoint)))
ggplot()+geom_density(aes(x=exp(ravJoint)))

#now back to model: Poisson with AR1




str(dat)

start.time <- Sys.time()
nullPoissonAR1Hierarchical <-  ulam(
  alist(
    interventions ~ dpois( lambda),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
#   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic

compare(nullPoisson, nullPoissonVolunteer,
        nullPoissonHierarchical,
        nullPoissonAR1Hierarchical)

precis(nullPoissonAR1Hierarchical, depth = 2)

#awesome progress with AR1

#now let's see if zero inflated makes sense

start.time <- Sys.time()
nullPoissonAR1HierarchicalZI <-  ulam(
  alist(
    interventions ~ dzipois(p, lambda),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5),
    logit(p) <- pp[volunteerID],
    pp[volunteerID] ~ dnorm(-1.5,1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic


compare(nullPoisson, nullPoissonVolunteer,
        nullPoissonHierarchical,
        nullPoissonAR1Hierarchical,
        nullPoissonAR1HierarchicalZI)

#Whoa, ZI is pretty awesome!




#now let's see if negative binomial 
#does better

start.time <- Sys.time()
nullNbinAR1Hierarchical <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5),
    phi <- puser[volunteerID],
    puser[volunteerID] ~ dexp(1)
  ), data=dat, log_lik = TRUE, 
  chains = 2, cores = 2, 
  iter = 5000,
  constraints = list(
    lambda = "lower = 0.00001, upper = 5",
    l = "lower = 0.00001, upper = 5",
    lbar = "lower = 0.00001, upper = 5",
    lsigmabar = "lower =  0.00001, upper = 5",
    a = "lower = 0.00001, upper = 5",
    abar = "lower = 0.00001, upper = 5",
    asigmabar = "lower = 0.00001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic



#compare(nullPoisson, nullPoissonVolunteer,
#        nullPoissonHierarchical,
#        nullPoissonAR1Hierarchical,
#        nullPoissonAR1HierarchicalZI,
#        nullNbinAR1Hierarchical)


#now consider days from the beginning


str(dat)

start.time <- Sys.time()
nullNbinAR1DoPHierarchical <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + a[volunteerID] * interventionsL1 + enth[volunteerID] * daysOfProject,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    a[volunteerID] ~ dnorm(abar, asigmabar),
    abar ~ dnorm(0, .3),
    asigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
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
    a = "lower = -1.5, upper = 5",
    abar = "lower = -1.5, upper = 5",
    asigmabar = "lower = 0.0001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic



#compare(nullNbinAR1Hierarchical,nullNbinAR1DoPHierarchical)

#yeah, DoP wins! Can we drop AR1?

  
start.time <- Sys.time()
nullNbinDoPHierarchical <-  ulam(
  alist(
    interventions ~ dgampois(lambda,phi),
    log(lambda) <- l[volunteerID] + enth[volunteerID] * daysOfProject,
    l[volunteerID] ~ dnorm(lbar,lsigmabar),
    lbar ~ dnorm(2, .9),
    lsigmabar ~ dexp(.5),
    enth[volunteerID] ~ dnorm(enthbar, enthsigmabar),
    enthbar ~ dnorm(0, .3),
    enthsigmabar ~ dexp(.5),
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
    enthsigmabar = "lower = 0.0001, upper = 5"
  ),
  control =
    list(max_treedepth = 14, adapt_delta = 0.9),
  #   cmdstan = TRUE
)
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
playMusic

exp(0)
exp(-2)
exp(5)
exp(-20)

compare(nullNbinAR1DoPHierarchical,nullNbinDoPHierarchical)

#AR1 element is a bit useful, but! including it is post-treatment bias!

exp(-3)

precis(nullNbinDoPHierarchical, depth = 2)

exp(0.01)

exp(-0.18)

exp(1.04)

exp(-0.11)

exp(0.82)

exp(1.46)
