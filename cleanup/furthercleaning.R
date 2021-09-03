library(dplyr)
library(tidyverse)
library(WRS2)
library(purrr)
library(rethinking)



AllClean <- readRDS(file = "datasets/RAWNESTA/AllClean.rds")
AllHate <- readRDS(file = "datasets/RAWNESTA/HateClean.rds")

#AllHate <- read.csv("HateClean.csv")
#AllClean <- read.csv("AllClean.csv")
#usernames is a dataset of usernames identified for a study - I'm going to remove all users which do not belong to this list later on
usernames <- read.csv("usernames.csv", header=FALSE)

head(AllHate) #attacks only
head(AllClean) #comments 
head(usernames)
nrow(AllHate)
nrow(AllClean)
nrow(usernames)


colnames(usernames) <-  c("author")
head(usernames)


#filtering out rows which include usernames other than the one in "usernames" -- selecting study group members
Hate <- AllHate[AllHate$author %in% usernames$author, ]
head(Hate)
nrow(Hate)
#same for comments
Comments <- AllClean[AllClean$author %in% usernames$author, ]
head(Comments)
nrow(Comments)




#count unique
n_distinct(Hate$author) #693 - YEAH! This is the exact number of users selected for study, so the above formula worked 
n_distinct(Comments$author) #693


HateFreq <- xtabs(~ author + day, data = Hate) 
CommentsFreq <- xtabs(~ author + day, data = Comments)

head(HateFreq) #also 693 rows, hell yeah!
nrow(HateFreq)
head(CommentsFreq)
nrow(CommentsFreq)

length(colnames(HateFreq))

length(colnames(CommentsFreq))

which(!(colnames(CommentsFreq) %in%  colnames(HateFreq)))


colnames(CommentsFreq)[22]

colnames(HateFreq)

CommentsFreq <- CommentsFreq[,-22]



mean(colnames(CommentsFreq) == colnames(HateFreq))



#from table to dataframe
Hate <- spread(as.data.frame(HateFreq),day,Freq)
head(Hate)
nrow(Hate)

Comments <- spread(as.data.frame(CommentsFreq),day,Freq)
head(Comments)
nrow(Comments)


#----------------------------------------------
#select the extra period before the experiment started 9.03 - 7.05 - FOR PRIORS
#ncol(Hate)
#ncol(Comments)
#ExtraHate <- Hate %>% select(-45:-216)
#head(ExtraHate)
#ExtraComments <- Comments %>% select(-46:-217)
#head(ExtraComments)

#not sure why there is one more column in Comments - 31.03 is missing in hate - perhaps no attacks that day?
#ncol(ExtraHate)
#ncol(ExtraComments)

#summaries
#change column name
#colnames(ExtraHate) <- paste("h",1:44,sep="")
#head(ExtraHate)
#colnames(ExtraComments) <- paste("c",1:45,sep="")
#head(ExtraComments)

#-----------------------------------------------------




#remove users who were suspended or deleted their account during the study
usersDeleted <- read.csv("nesta_deleted.csv", header=FALSE)
head(usersDeleted)
usersSuspended <- read.csv("nesta_suspended.csv", header=FALSE)
head(usersSuspended)

colnames(usersDeleted) <-  c("author")
head(usersDeleted)

colnames(usersSuspended) <-  c("author")
head(usersSuspended)

nrow(usersDeleted) + nrow(usersSuspended)

usersToRemove <- rbind(usersDeleted,usersSuspended)
usersToRemove$author <- unique(usersToRemove$author)
head(usersToRemove)
nrow(usersToRemove)



head(Hate)
nrow(Hate)

Hate <- Hate[!(Hate$author %in% usersToRemove$author),]
Comments <- Comments[!(Comments$author %in% usersToRemove$author),]


#saveRDS(Hate, file = "Hate.rds")
#saveRDS(Comments, file = "Comments.rds")

Hate <- readRDS(file = "datasets/RAWNESTA/Hate.rds")
Comments <- readRDS(file = "datasets/RAWNESTA/Comments.rds")


dates <- colnames(Hate)[-1]

startDate <- dates[1]
interventionDate <- "2020-07-09"
observationDate <- "2020-09-10"
end <- dates[length(dates)]

periods<- numeric(length(dates))
periods <- ifelse(dates < interventionDate,"pre-treatment",periods)
periods <- ifelse(dates >= interventionDate & dates < observationDate,"treatment",periods)
periods <- ifelse(dates >= observationDate,"post-treatment",periods)
periods


periods<- numeric(length(dates))
periods <- ifelse(dates < startDate,"test",periods)
periods <- ifelse(dates >= startDate & dates < interventionDate,"pre-treatment",periods)
periods <- ifelse(dates >= interventionDate & dates < observationDate,"treatment",periods)
periods <- ifelse(dates >= observationDate,"post-treatment",periods)
periods <- c(NA,periods)

periods
length(colnames(Hate))
length(periods)


columnsDF <- data.frame(colnames(Hate), periods)

columnsDF



complete.cases(Hate)
complete.cases(Comments)

pretreatmentCodes <- which(columnsDF$periods == "pre-treatment")
treatmentCodes <- which(columnsDF$periods == "treatment")
posttreatmentCodes <- which(columnsDF$periods == "post-treatment")

pretreatmentCodes
treatmentCodes
posttreatmentCodes

pretreatmentCodes


as.vector(rowSums(Hate[,pretreatmentCodes]))


Summaries <- data.frame(author = Hate$author,
                    AB = as.vector(rowSums(Hate[,pretreatmentCodes])),
                    AD = as.vector(rowSums(Hate[,treatmentCodes])),
                    AA = as.vector(rowSums(Hate[,posttreatmentCodes])),
                    CB = as.vector(rowSums(Comments[,pretreatmentCodes])),
                    CD = as.vector(rowSums(Comments[,treatmentCodes])),
                    CA = as.vector(rowSums(Comments[,posttreatmentCodes]))
                    )

Summaries <- Summaries %>% mutate(Adiff = AA - AB, Cdiff = CA - CB)

Summaries$AdiffS <- standardize(Summaries$Adiff)
Summaries$CdiffS <- standardize(Summaries$Cdiff)






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
outboxlimit(Summaries$CB)

outliersCB <- Summaries$author[outbox(Summaries$CB)]
outliersCA <- Summaries$author[outbox(Summaries$CA)]
outliersAB <- Summaries$author[outbox(Summaries$AB)]
outliersAA <- Summaries$author[outbox(Summaries$AA)]
outliersCD <- Summaries$author[outbox(Summaries$CD)]
outliersAD <- Summaries$author[outbox(Summaries$AD)]



outliers <- unique(c(as.character(outliersCB),as.character(outliersCA),
  as.character(outliersAB),as.character(outliersAA),
  as.character(outliersCD),as.character(outliersAD)))

length(outliers)
write.csv(outliers, file = "datasets/outliers.csv")


#YEAH! 


#add groups

normative <- read.csv("datasets/RAWNESTA/usernamesnormative.csv")
normative
normativeIndicator <- Summaries$author %in% normative$user
normativeIndicator

empathy <- read.csv("datasets/RAWNESTA/usernamesempathy.csv")
empathy
empathyIndicator <- Summaries$author %in% empathy$user
empathyIndicator

control <- read.csv("datasets/RAWNESTA/usernamescontrol.csv")
control
controlIndicator <- Summaries$author %in% control$user
controlIndicator

normativeIndicator + empathyIndicator + controlIndicator

group <- ifelse(normativeIndicator == TRUE,"normative", 
                ifelse(empathyIndicator == TRUE, "empathy", 
                       "control"))

group

Summaries$group <- group

Summaries


#saveRDS(Summaries, file = "datasets/Summaries.rds")
#write.csv(Summaries,"datasets/Summaries.csv")
