library(data.table)
library(tidyverse)
library(ggplot2)
library(scales)
library(dplyr)


Nall <- as.data.frame(fread("nesta_all.txt",quote=""))
NallCont <- as.data.frame(fread("nesta_all_cont.txt",quote = ""))
NallTest <- as.data.frame(fread("nesta_all_test.txt",quote = ""))
Nhate <- as.data.frame(fread("nesta_hate.txt",quote = ""))
NhateCont <- as.data.frame(fread("nesta_hate_cont.txt",quote = ""))
NhateTest <- as.data.frame(fread("nesta_hate_test.txt",quote = ""))
NallNew <- as.data.frame(fread("nesta_3_all.txt",quote=""))
NhateNew <- as.data.frame(fread("nesta_3_hate.txt",quote=""))

head(Nall)
head(NallCont)
head(NallTest)
head(Nhate)
head(NhateCont)
head(NhateTest)
head(NallNew)
head(NhateNew)

colnames(Nall) <-  c("id", "timestamp", "author","text","subreddit")
colnames(NallCont) <-  c("id", "timestamp", "author","text","subreddit")
colnames(NallTest) <-  c("id", "timestamp", "author","text","subreddit")
colnames(Nhate) <-  c("id", "timestamp", "author","text","subreddit", "redditFilter","violence", "rules")
colnames(NhateCont) <-  c("id", "timestamp", "author","text","subreddit", "redditFilter","violence", "rules")
colnames(NhateTest) <-  c("id", "timestamp", "author","text","subreddit", "redditFilter","violence", "rules")
colnames(NallNew) <-  c("id", "timestamp", "author","text","subreddit")
colnames(NhateNew) <-  c("id", "timestamp", "author","text","subreddit", "redditFilter","violence", "rules")


head(Nall)
head(NallCont)
head(NallTest)
head(Nhate)
head(NhateCont)
head(NhateTest)
head(NallNew)
head(NhateNew)

nrow(NallNew)
nrow(NhateNew)

#convert time stamps to dates
Nall$day <- as.Date(as.POSIXct(Nall$timestamp, origin="1970-01-01"))
NallCont$day <- as.Date(as.POSIXct(NallCont$timestamp, origin="1970-01-01"))
NallTest$day <- as.Date(as.POSIXct(NallTest$timestamp, origin="1970-01-01"))
Nhate$day <- as.Date(as.POSIXct(Nhate$timestamp, origin="1970-01-01"))
NhateCont$day <- as.Date(as.POSIXct(NhateCont$timestamp, origin="1970-01-01"))
NhateTest$day <- as.Date(as.POSIXct(NhateTest$timestamp, origin="1970-01-01"))
NallNew$day <- as.Date(as.POSIXct(NallNew$timestamp, origin="1970-01-01"))
NhateNew$day <- as.Date(as.POSIXct(NhateNew$timestamp, origin="1970-01-01"))


#inspect
head(Nall)
head(NallCont)
head(NallTest)
head(Nhate)
head(NhateCont)
head(NhateTest)

#double check the time range
min(Nall$day)
max(Nall$day)

min(NallCont$day)
max(NallCont$day)

min(NallTest$day)
max(NallTest$day) 

min(Nhate$day)
max(Nhate$day) 

min(NhateCont$day)
max(NhateCont$day) 

min(NhateTest$day)
max(NhateTest$day) 

min(NallNew$day)
max(NallNew$day) 

min(NhateNew$day)
max(NhateNew$day) 


NallTotal <- rbind(Nall, NallCont, NallTest, NallNew)
NHateTotal <- rbind(Nhate, NhateCont, NhateTest, NhateNew)

nrow(NallTotal) #5362860
nrow(NHateTotal) #88907
min(NHateTotal$day)
max(NHateTotal$day)
min(NallTotal$day)
max(NallTotal$day)

getwd()
#remove duplicates
NallTotalClean <- NallTotal[!duplicated(NallTotal$id), ]
#all <- NallTotalClean
NHateTotalClean <- NHateTotal[!duplicated(NHateTotal$id), ]
nrow(NHateTotalClean)
head(NallTotalClean)

head(NHateTotalClean)
colnames(NHateTotalClean)

head(NallTotalClean)

saveRDS(NHateTotalClean, file = "hateCleanComplete.rds")
saveRDS(NallTotalClean, file = "allCleanComplete.rds")

#includes text
write.csv(NallTotalClean,"All.csv")
write.csv(NHateTotalClean,"HateAll.csv")




AllClean <-  NallTotalClean %>% select(-4,-5,-6) #removed text, subreddit, NA
head(AllClean)
nrow(AllClean)

HateClean <-  NHateTotalClean %>% select(-c(text,subreddit,redditFilter,violence,rules)) 
head(HateClean)
nrow(HateClean)


allClean <- readRDS(file = "AllClean.rds")

saveRDS(AllClean, file = "AllClean.rds")
saveRDS(HateClean, file = "HateClean.rds")


#write.csv(AllClean,"AllClean.csv")
#write.csv(HateClean,"HateClean.csv")

#remove attacks from all
#common <- intersect(AllClean$id,HateClean$id)
#AllCleanNoRepeats <- AllClean[which(!AllClean$id %in% common),]

#head(AllCleanNoRepeats)
#nrow(AllCleanNoRepeats)
#write.csv(AllCleanNoRepeats,"AllCleanNoRepeats.csv")

