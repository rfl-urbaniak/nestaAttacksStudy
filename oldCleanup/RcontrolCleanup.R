library(data.table)
library(tidyverse)
library(ggplot2)
library(scales)

#_________ load files, select & rename columns, inspect attacks
#we load twice to be able to inspect raw data at all times
RcontrolAttacks <- as.data.frame(fread("Rcontrol_attacks_final.txt",quote = ""))
RcontrolAttacksRaw <- as.data.frame(fread("Rcontrol_attacks_final.txt",quote = ""))


# rename columns, use camelCase throughout the project!!
colnames(RcontrolAttacks) <-  c("id", "utc", "author","text","subreddit", "parentID","link", "high", "low","rules", "receiver", "replyToPost")
colnames(RcontrolAttacksRaw) <-  c("id", "utc", "author","text","subreddit", "parentID","link", "high", "low","rules", "receiver", "replyToPost")


#take a look
head(RcontrolAttacks)


# remove columns not used in the aggregation
RcontrolAttacksClean <-  RcontrolAttacks %>% select(-c(text,parentID,link,rules)) 

#inspect again
head(RcontrolAttacksClean)

#convert time stamps to dates
RcontrolAttacksClean$day <- as.Date(as.POSIXct(RcontrolAttacksClean$utc, origin="1970-01-01"))


#inspect
head(RcontrolAttacksClean)

#double check the time range
min(RcontrolAttacksClean$day)
max(RcontrolAttacksClean$day) 


#take a look at at distribution in time to look for anomalies
ggplot(RcontrolAttacksClean, aes(x=day))+geom_histogram(bins = 15)+
  scale_x_date(date_breaks = "days" , date_labels = "%d.%m")+
  geom_vline(xintercept = as.Date("2020-07-02"))+ theme_minimal(base_size = 8)


#save file for further use
write.csv(RcontrolAttacksClean,"RcontrolAttacksClean.csv")

#________________________________
#now, similar cleaning for the comments; will rbind with removing duplicates later on
RcontrolComments <- as.data.frame(fread("Rcontrol_comments_final.txt",quote = ""))

head(RcontrolComments)

colnames(RcontrolComments) <-  c("id", "utc", "author","text","subreddit", "parentID","link", "high", "low","rules", "receiver", "replyToPost")

RcontrolCommentsClean <-  RcontrolComments %>% select(-c(text,parentID,link,rules)) 
head(RcontrolCommentsClean)

RcontrolCommentsClean$day <- as.Date(as.POSIXct(RcontrolCommentsClean$utc, origin="1970-01-01"))

head(RcontrolCommentsClean)

min(RcontrolCommentsClean$day)
max(RcontrolCommentsClean$day) 


ggplot(RcontrolCommentsClean, aes(x=day))+geom_histogram(bins = 15)+
  scale_x_date(date_breaks = "days" , date_labels = "%d.%m")+
  geom_vline(xintercept = as.Date("2020-07-02"))+ theme_minimal(base_size = 8)


#remove lines already in attacks
common <- intersect(RcontrolCommentsClean$id,RcontrolAttacksClean$id)
RcontrolCommentsNoRepeats <- RcontrolCommentsClean[which(!RcontrolCommentsClean$id %in% common),]

head(RcontrolCommentsNoRepeats)
nrow(RcontrolCommentsNoRepeats)

write.csv(RcontrolCommentsNoRepeats,"RcontrolCommentsNoRepeats.csv")

