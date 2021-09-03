library(tidyverse)
library(dplyr)
library(purrr)
library(WRS2)

summaries <- readRDS(file = "datasets/Summaries.rds")
interventions <- read.csv("datasets/RAWNESTA/interventions.csv")
head(interventions)
head(summaries)
str(interventions)
interventions$day <-  as.Date(as.POSIXct(interventions$day, origin="1970-01-01"))
colnames(interventions)[5] <- "author"

min(interventions$day)
max(interventions$day)

#sum wrong interventions
nrow(interventions) #1661
sum(interventions[, 'wrong'], na.rm = TRUE) #23 wrong interventions (out of 1662)

#checking how many users received at least one intervention - 307
n_distinct(interventions$user) 

#checking whether no typos were made in usernames in intervention file
usernames <- read.csv("datasets/RAWNESTA/usernames.csv", header=FALSE)
colnames(usernames) <-  c("author")
head(usernames)
mean(interventions$author %in% usernames$author)
#no interventions with users not on the list


nrow(interventions) #1661 interventions (1 less than step before, ok)
sum(interventions[, 'wrong'], na.rm = TRUE) #23 wrong, nothing has changed here

sum(interventions$emp) #770
sum(interventions$norm) #887


#select those usernames who received wrong intervention
wrongTreat <- filter(interventions, wrong=="1")
head(wrongTreat)
nrow(wrongTreat) #23 correct

wrongTreat$author
wrongTreat$author[duplicated(wrongTreat$author)]

wrongUsers <- as.character(unique(wrongTreat$author)) #19
wrongUsers
sum(wrongUsers %in% summaries$author) #11 to be removed



all <- readRDS(file = "datasets/RAWNESTA/AllClean.rds")
hate <- readRDS(file = "datasets/RAWNESTA/HateClean.rds")

sum(wrongUsers %in% all$author) #11 to be removed
sum(wrongUsers %in% hate$author) #11 to be removed


usersDeleted <- read.csv("datasets/RAWNESTA/nesta_deleted.csv", header=FALSE)

nrow(usersDeleted)
usersSuspended <- read.csv("datasets/RAWNESTA/nesta_suspended.csv", header=FALSE)
nrow(usersSuspended)

usersToRemove <- rbind(usersDeleted,usersSuspended)

removed <- unique(as.character(usersToRemove$V1))

sum(wrongUsers %in% removed) 




summaries[summaries$author %in% wrongUsers,] #11 remaining users deleted or removed

summaries <- summaries[!(summaries$author %in% wrongUsers),]

table(summaries$group)


#saveRDS(summaries, file = "datasets/Summaries.rds")
#write.csv(summaries,"datasets/Summaries.csv")

head(interventions)


sum(usersSuspended$V1 %in% interventions$author)  #55

sum(usersDeleted$V1 %in% interventions$author)    #12


sum(interventions$author %in% removed)      #368 interventions on users deleted or removed


interventions <- interventions[!(interventions$author %in% removed),]

head(interventions)


nrow(interventions)

#removed users with wrong treatment
length(wrongUsers)

interventions <- interventions[!(interventions$author %in% wrongUsers),]




#two corrections
interventions[which(interventions[,2] + interventions[,3] == 0),]$norm <- c(1,1)

interventions$author <- as.character(interventions$author)

str(interventions)

mean(interventions$author %in% summaries$author)

length(unique(interventions$author))

interventions

saveRDS(interventions, file = "datasets/interventions.rds")
write.csv(interventions,"datasets/interventions.csv")



interventionsByAuthor <- xtabs(~ author, data = interventions)


interventionsByAuthor <- data.frame(interventionsByAuthor)

interventionsByAuthor$author <- as.character(interventionsByAuthor$author)

str(interventionsByAuthor)


str(interventionsByAuthor$author)


interventionsByAuthor$author %in% summaries$author





summaries <- merge(x = summaries, y = interventionsByAuthor, by = "author", all.x = TRUE)

names(summaries)


names(summaries)[names(summaries) == 'Freq'] <- 'IC'

summaries$IC[is.na(summaries$IC)] <- 0


head(summaries)

sum(summaries[summaries$group != "control",]$IC == 0)  #34 from treatment didn't get any intervention

sum(summaries$IC!=0)  #229

table(summaries[summaries$IC!=0,]$group)

table(summaries[summaries$IC==0,]$group)


saveRDS(summaries, file = "datasets/Summaries.rds")
write.csv(summaries,file = "datasets/Summaries.csv")

head(summaries)


head(summaries)

#by day

str(interventions)

#moving 34 people with IC=0 to control
summaries[summaries$group != "control" & summaries$IC == 0,]$group <- "control"




saveRDS(summaries, file = "datasets/Summaries.rds")
write.csv(summaries,"datasets/Summaries.csv")





interventionsByDay <- xtabs(sum ~ author + day, data = interventions)


str(interventionsByDay)

interventionsByDay

ncol(interventionsByDay)

saveRDS(interventionsByDay, file = "datasets/interventionsByDay.rds")
write.csv(interventionsByDay,"datasets/interventionsByDay.csv")








