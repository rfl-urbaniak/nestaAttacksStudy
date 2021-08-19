library(dplyr)
library(tidyverse)
library(WRS2)

#load list of sampled users with bots removed
RcontrolList<- read.csv("RcontrolListNoBots.csv",header=TRUE)[,1]

#load the dataset
RcontrolAttacks <- read.csv("RcontrolAttacksClean.csv")

#load the comments dataset
RcontrolCommentsNoRepeats <- read.csv("RcontrolCommentsNoRepeats.csv")

#rbind
RcontrolAll <- rbind(RcontrolAttacks,RcontrolCommentsNoRepeats)

head(RcontrolAll)
nrow(RcontrolAll)

#double check to remove duplicates by ID
RcontrolUnique <- RcontrolAll %>% distinct(RcontrolAll$id, .keep_all=TRUE)

head(RcontrolUnique)

#now drop the additional id column
RcontrolUnique <- RcontrolUnique[,-11]

#check length and colnames
nrow(RcontrolUnique)
colnames(RcontrolUnique)

#rename for brevity
Rcontrol <- RcontrolUnique

#inspect 
head(Rcontrol)

#now we tabulate attacks of two types by day and receiver [mind your head! this is for attacks received, you need to do something slighlty different if you want activity counts and if you split by weeks etc]
#_____ counting received: rl - received low, rh - received high,  rpl - received to post low, rph  - received to post high

RcontrolFreqL <- xtabs(low  ~ receiver + day, data = Rcontrol)
RcontrolFreqH <- xtabs(high  ~ receiver + day, data = Rcontrol)
RcontrolFreqPl <- xtabs(low * replyToPost  ~ receiver + day, data = Rcontrol)
RcontrolFreqPh <- xtabs(high * replyToPost  ~ receiver + day, data = Rcontrol)
RcontrolFreqA <- xtabs(~ author + day, data = Rcontrol)



head(RcontrolFreqL)
head(RcontrolFreqH)
head(RcontrolFreqPl)
head(RcontrolFreqPh)
head(RcontrolFreqA)

# add day numbers pated after attack type as colnames
colnames(RcontrolFreqL) <- paste("l",1:15,sep="")
colnames(RcontrolFreqH) <- paste("h",1:15,  sep = "")
colnames(RcontrolFreqPl) <- paste("pl",1:15,  sep = "")
colnames(RcontrolFreqPh) <- paste("ph",1:15, sep = "")
colnames(RcontrolFreqA) <- paste("au",1:15, sep = "")

#inspect, as usual
head(RcontrolFreqH)
head(RcontrolFreqPl)
head(RcontrolFreqPh)
head(RcontrolFreqA)

#now back from xtabs to dataframes
L <- spread(as.data.frame(RcontrolFreqL),day,Freq)
H <- spread(as.data.frame(RcontrolFreqH),day,Freq)
Pl <- spread(as.data.frame(RcontrolFreqPl),day,Freq)
Ph <- spread(as.data.frame(RcontrolFreqPh),day,Freq)
A <- spread(as.data.frame(RcontrolFreqA),day,Freq)


#inspect the structure
str(RcontrolFreqL)
str(L)

#now put these togther, joining by receiver [mind your head, if you track activity, you will be working with users, not receivers; here we later call receivers users!]
RcontrolFreqFull <- full_join(L,H, by="receiver")
RcontrolFreqFull <- full_join(RcontrolFreqFull,Pl, by = "receiver")
RcontrolFreqFull <- full_join(RcontrolFreqFull,Ph, by = "receiver")

colnames(RcontrolFreqFull)[1] <- "user"
colnames(A)[1] <- "user"
RcontrolFreqFull <- full_join(RcontrolFreqFull,A, by = "user")

#replace NAs with 0s [use with caution and makes you know why you do this!!]
for(c in 2:76){
  RcontrolFreqFull[is.na(RcontrolFreqFull[,c]),c] <- 0
}

RcontrolFreqFull

#now you want days next to each other
order <- numeric()
for(x in 2:16){
  order <-  append(order, seq(x,76,by=15)) 
}

RcontrolFreqFull <- RcontrolFreqFull[,c(1,order)]

#sanity check
head(RcontrolFreqFull)
nrow(RcontrolFreqFull)

#now double check if you don't have reduntant users not in your control group list and throw them away
RcontrolFreqFinal <- RcontrolFreqFull[which(RcontrolFreqFull$user %in% RcontrolList),]


nrow(RcontrolFreqFinal)

#add summaries by periods
RcontrolWithSummaries <- RcontrolFreqFull %>% mutate(sumLowBefore = l1+l2+l3+l4+l5+l6+l7) %>%
  mutate(sumHighBefore = h1+h2+h3+h4+h5+h6+h7) %>%
  mutate(sumPlBefore = pl1+pl2+pl3+pl4+pl5+pl6+pl7) %>%
  mutate(sumPhBefore = ph1+ph2+ph3+ph4+ph5+ph6+ph7) %>%
  mutate(activityBefore = au1+au2+au3+au4+au5+au6+au7) %>%
  mutate(activityAfter = au9+au10+au11+au12+au13+au14+au15) %>%
  mutate(activityDiff = activityAfter- activityBefore )

head(RcontrolWithSummaries)  


# again, remove users not on list
RcontrolWithSummaries <- RcontrolWithSummaries[RcontrolWithSummaries$user %in% RcontrolList,]

head(RcontrolWithSummaries)
nrow(RcontrolWithSummaries)


##Remove all control members with non-zero attacks before
RcontrolWithSummaries <-  RcontrolWithSummaries %>% filter(sumLowBefore == 0)

nrow(RcontrolWithSummaries)

#look at outliers
#first, function finding limits for outliers
outboxlimit <- function(vector){
  mean(vector) + 1.5 * IQR(vector)
}

#then function locating outliers
outbox <- function(vector) {
  which(vector >  mean(vector) + 1.5 * IQR(vector))
}

#see limits and drag outliers out
outboxlimit(RcontrolWithSummaries$activityBefore)
RCauBeforeOutliers <- outbox(RcontrolWithSummaries$activityBefore)

outboxlimit(RcontrolWithSummaries$activityAfter)
RCauAfterOutliers <- outbox(RcontrolWithSummaries$activityAfter)

#outlier numbers
RCoutliers <- unique(c(RCauBeforeOutliers,RCauAfterOutliers))

length(RCoutliers)

#get rows for outliers
RCoutliersTable <- RcontrolWithSummaries[RCoutliers,]


RCoutliersTable

nrow(RCoutliersTable)

#list outlier names
RCoutliersTable$user

#save if needed 
write.csv(RCoutliersTable, "data/RcontrolOutliers.csv")



nrow(RcontrolWithSummaries)


#now this makes sense later on once you have someone checked for bots, and the details depend on the data format you get
botsVerified <- read.csv("BotsVerified2.csv")
colnames(botsVerified) <- c("user","result","comment")
botsVerified$user <- as.character(botsVerified$user)
str(botsVerified)

head(botsVerified)

nrow(RcontrolWithSummaries)


sum(RcontrolWithSummaries$user %in% botsVerified$user[botsVerified$result == 0])

#clean up using the list
RcontrolCleaned <- RcontrolWithSummaries[!RcontrolWithSummaries$user %in% botsVerified$user[botsVerified$result == 0],]
RcontrolCleaned <- RcontrolCleaned[RcontrolCleaned$user != "davidjl123",]

nrow(RcontrolCleaned)

head(RcontrolCleaned)

#add column info about group
RcontrolCleaned$group <- c("Rcontrol")
RcontrolCleaned$treatment <- 0




write.csv(RcontrolWithSummaries,"RcontrolWithSummaries.csv")
write.csv(RcontrolCleaned,"RcontrolCleaned.csv")







#double check you have no attacks before in the control group
table(RcontrolWithSummaries$sumLowBefore)
table(RcontrolWithSummaries$sumHighBefore)
table(RcontrolWithSummaries$sumPlBefore)
table(RcontrolWithSummaries$sumHighBefore)


#________________________________________________________________________
#long format, if you need it (say, for plotting) ignore otherwise

RcontrolLong <- gather(RcontrolCleaned,type,count,l1:au15)

head(RcontrolLong)

RcontrolLong$day <- as.numeric(gsub("[^0-9.]", "",RcontrolLong$type))

str(RcontrolLong$day)

RcontrolLong$type <-gsub("[^a-zA-Z]", "", RcontrolLong$type)
RcontrolLong$type <- as.factor(RcontrolLong$type)
head(RcontrolLong)



write.csv(RcontrolLong, "RcontrolLong.csv")













