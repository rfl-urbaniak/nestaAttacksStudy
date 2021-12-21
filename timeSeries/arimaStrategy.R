library(rethinking)
library(tidyverse)
library(ggthemes)
library(stats)
library(forecast)

getwd()


data <- read.csv("quittingFinalAnon.csv")
attacked <- data[data$sumHighBefore >=1,]


userArimaDFs <- list()

for(i in 1:nrow(attacked)){
user <- attacked[i,]
activity <- as.integer(t(user[,c(paste("au",1:15, sep = ""))]))
attacks <- as.integer(t(user[,c(paste("h",1:15, sep = ""))]))

postAttacks <- as.integer(t(user[,c(paste("ph",1:15, sep = ""))]))
commentAttacks <-  as.integer(t(user[,c(paste("h",1:15, sep = ""))])) - as.integer(t(user[,c(paste("ph",1:15, sep = ""))]))

userDF <- data.frame(activity,postAttacks,commentAttacks, attacks)
userDF <-userDF %>% mutate(attacksCumulative = cumsum(attacks))
userDF <-userDF %>% mutate(attacksLag = lag(attacks,1))
cumlag <- cumsum(ifelse(is.na(userDF$attacksLag), 0, userDF$attacksLag))
userDF <-userDF %>% mutate(attacksLagCumulative = cumlag)
userArimaDFs[[i]] <- userDF
}

#build bare arimas
bareArimas <- list()
for (i in 1:length(userArimaDFs)){
bareArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],stationary=TRUE)
}

#collectbare akaike scores
bareAIC <- numeric(length(userArimaDFs))
for (i in 1:length(userArimaDFs)){
bareAIC[i] <- bareArimas[[i]][["aicc"]]
}

#build arimas with today attacks

todayArimas <- list()
#for (i in 15:length(userArimaDFs)){
#  todayArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
#                                 xreg=userArimaDFs[[i]]$attacks[2:14],stationary=TRUE)
#}

for (i in 1:length(userArimaDFs)){
skip_to_next <- FALSE

tryCatch(   todayArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
                                           xreg=userArimaDFs[[i]]$attacks[2:14],stationary=TRUE),
          error = function(e) { skip_to_next <<- TRUE})

if(skip_to_next) { next } 
}

todayArimasCleaned <-  todayArimas[-which(sapply(todayArimas, is.null))]

#needed to drop 38 users

#extract AIC from today arimas
todayAIC <- numeric(length(todayArimasCleaned))
for (i in 1:length(todayArimasCleaned)){
  todayAIC[i] <- todayArimasCleaned[[i]][["aicc"]]
}



#no strong reason to think today's attacks are very useful
ggplot()+geom_density(aes(x = bareAIC))+geom_density(aes(x=todayAIC), color = "skyblue")





#build arimas with yesterday attacks

yesterdayArimas <- list()

for (i in 1:length(userArimaDFs)){
  skip_to_next <- FALSE
  
  tryCatch(   yesterdayArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
                                             xreg=userArimaDFs[[i]]$attacksLag[2:14],stationary=TRUE),
              error = function(e) { skip_to_next <<- TRUE})
  
  if(skip_to_next) { next } 
}



#yesterdayArimasCleaned <-  yesterdayArimas[-which(sapply(yesterdayArimas, is.null))]
#length(yesterdayArimas)
#length(yesterdayArimasCleaned)

#extract AIC from yesterday arimas
yesterdayAIC <- numeric(length(yesterdayArimas))
for (i in 1:length(yesterdayArimas)){
  yesterdayAIC[i] <- yesterdayArimas[[i]][["aicc"]]
}


ggplot()+geom_density(aes(x = bareAIC))+geom_density(aes(x=todayAIC), color = "skyblue")+
geom_density(aes(x=yesterdayAIC), color = "orange")


userDF

#how about cumulative attacks
cumulativeArimas <- list()
for (i in 1:length(userArimaDFs)){
  skip_to_next <- FALSE
  
  tryCatch(   cumulativeArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
                                             xreg=userArimaDFs[[i]]$attacksCumulative[2:14],stationary=TRUE),
              error = function(e) { skip_to_next <<- TRUE})
  
  if(skip_to_next) { next } 
}

#extract AIC from cumulative arimas
cumulativeAIC <- numeric(length(cumulativeArimas))
for (i in 1:length(cumulativeArimas)){
  cumulativeAIC[i] <- cumulativeArimas[[i]][["aicc"]]
}


ggplot()+geom_density(aes(x = bareAIC))+geom_density(aes(x=todayAIC), color = "skyblue")+
  geom_density(aes(x=yesterdayAIC), color = "orange")+
  geom_density(aes(x=cumulativeAIC), color = "skyblue", lty=2)



userDF
#cumulative lagged arimas
#how about cumulative attacks
cumulativeLagArimas <- list()
for (i in 1:length(userArimaDFs)){
  skip_to_next <- FALSE
  
  tryCatch(   cumulativeLagArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
                                                  xreg=userArimaDFs[[i]]$attacksLagCumulative[2:14],stationary=TRUE),
              error = function(e) { skip_to_next <<- TRUE})
  
  if(skip_to_next) { next } 
}

#extract AIC from cumulative arimas
cumulativeLagAIC <- numeric(length(cumulativeLagArimas))
for (i in 1:length(cumulativeLagArimas)){
  cumulativeLagAIC[i] <- cumulativeLagArimas[[i]][["aicc"]]
}



ggplot()+geom_density(aes(x = bareAIC))+geom_density(aes(x=todayAIC), color = "skyblue")+
  geom_density(aes(x=yesterdayAIC), color = "orange")+
  geom_density(aes(x=cumulativeAIC), color = "skyblue", lty=2)+
  geom_density(aes(x=cumulativeLagAIC), color = "orange", lty=2)



cumulativeLagXreg <- numeric(length(cumulativeLagArimas))
for(i in 1:length(cumulativeLagArimas)){
cumulativeLagXreg[i] <- cumulativeLagArimas[[i]]$coef[2]
}


yesterdayXreg <- numeric(length(yesterdayArimas))
for(i in 1:length(yesterdayArimas)){
  yesterdayXreg[i] <- yesterdayArimas[[i]]$coef[2]
}


todayXreg <- numeric(length(todayArimasCleaned))
for(i in 1:length(todayArimasCleaned)){
  todayXreg[i] <- todayArimasCleaned[[i]]$coef[2]
}





library(ggpubr)
ggarrange(ggplot()+geom_density(aes(x=cumulativeLagXreg))+xlim(c(-3,5)),
ggplot()+geom_density(aes(x=yesterdayXreg))+xlim(c(-3,5)),
ggplot()+geom_density(aes(x=todayXreg))+xlim(c(-3,5)), ncol = 1)


median(yesterdayXreg, na.rm=TRUE)
median(cumulativeLagXreg, na.rm=TRUE)
median(todayXreg, na.rm=TRUE)


#once again cumulativeLag with comparison to bare


cumulativeLagArimas <- list()
bareArimas <- list()
for (i in 1:length(userArimaDFs)){
  
cumulativeLagArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
              xreg=userArimaDFs[[i]]$attacksLagCumulative[2:14],stationary=TRUE)
bareArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],stationary=TRUE)  
}


bareArimas[[3]]
cumulativeLagArimas[[3]]



cumulativeLagXreg <- numeric(length(cumulativeLagArimas))
for(i in 1:length(cumulativeLagArimas)){
  cumulativeLagXreg[i] <- cumulativeLagArimas[[i]]$coef[2]
}



AICcumLagImprovement <- numeric(length(cumulativeLagArimas))
for(i in 1:length(cumulativeLagArimas)){
AICcumLagImprovement[i] <- cumulativeLagArimas[[i]][["aicc"]]- bareArimas[[i]][["aicc"]]
}


ggplot()+geom_density(aes(x=AICcumLagImprovement))

mean(AICcumLagImprovement)

userDF

yesterdayArimas <- list()
bareArimas <- list()
for (i in 1:length(userArimaDFs)){
  
  yesterdayArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
                                         xreg=userArimaDFs[[i]]$attacksLag[2:14],stationary=TRUE)
  bareArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],stationary=TRUE)  
}



AICyesterdayImprovement <- numeric(length(yesterdayArimas))
for(i in 1:length(yesterdayArimas)){
  AICyesterdayImprovement[i] <- yesterdayArimas[[i]][["aicc"]]- bareArimas[[i]][["aicc"]]
}



cumulativeLagArimas[[25]]
bareArimas[[25]]


ggplot()+geom_density(aes(x=AICyesterdayImprovement))

mean(AICyesterdayImprovement)


#notice se is large relative to estimates, AIC differences are really small



  
  skip_to_next <- FALSE
  
tryCatch(cumulativeLagArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],
              xreg=userArimaDFs[[i]]$attacksLagCumulative[2:14],stationary=TRUE)
         
         bareArimas[[i]] <- auto.arima(userArimaDFs[[i]]$activity[2:14],stationary=TRUE)
         

           
           ,
              error = function(e) { skip_to_next <<- TRUE})
  
  if(skip_to_next) { next } 
}







