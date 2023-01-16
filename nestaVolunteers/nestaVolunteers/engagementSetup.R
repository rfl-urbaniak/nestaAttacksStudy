library(data.table)
library(tidyverse)
library(ggplot2)
library(scales)
library(dplyr)
library(janitor)
library(spatstat.utils)
library(useful)
library(ggthemes)

#setwd("~/Desktop/nestaVolunteers")


volunteers <- read.csv(file = "volunteers.csv")

head(volunteers, n = 20)
nrow(volunteers) #1755


#remove empty rows

volunteersCleaned <- volunteers[!apply(volunteers == "", 1, all), ] 

nrow(volunteersCleaned)
head(volunteersCleaned)

#interventions per day
volunteersDate <- t(xtabs(~Volunteer.name + Date, data=volunteersCleaned))

head(volunteersDate)
ncol(volunteersDate)
nrow(volunteersDate)
str(volunteersDate)

sort(colnames(volunteersDate))

write.csv(volunteersDate, "volunteersDate.csv")

#write and read csv to get rid of the xtabs format
volunteersDateCSV <- read.csv(file = "volunteersDate.csv")

head(volunteersDateCSV)
str(volunteersDateCSV)
ncol(volunteersDateCSV)
colnames(volunteersDateCSV)


volunteersDateCSVRemove <- volunteersDateCSV[,-2]
head(volunteersDateCSVRemove)
nrow(volunteersDateCSVRemove)

colnames(volunteersDateCSVRemove)[1] <- "Date"

str(volunteersDateCSVRemove)

volunteersDateCSVRemove$bicycleflossing

volunteersDateCSVRemove$Date <- as.Date(volunteersDateCSVRemove$Date)


sort(colnames(volunteersDateCSVRemove))

head(volunteersDateCSVRemove)
nrow(volunteersDateCSV)


#now additional info about joint identities
joinDates <- read_csv("joinDates.csv")
head(joinDates)


# 
# volunteersDateCSVRemove %>% select(Date,ChubbyhappyBuddha, PipperPapper)
# 
# volunteersDateCSVRemove <- volunteersDateCSVRemove %>% 
#   mutate(ChubbyhappyBuddhaPipperPapper = ChubbyhappyBuddha + PipperPapper) %>%
#   select(- c(ChubbyhappyBuddha,PipperPapper))
# 
# volunteersDateCSVRemove %>% select(Date,ChubbyhappyBuddha, PipperPapper)
# 

#now programmatically


rows <- c(1, 2, 3, 4, 6, 9, 15, 16)



row <- 16

first <-  joinDates$`Volunteer Reddit`[row]
second <- joinDates$`Additional Reddit/same username`[row]
  
first
second 
  
  
eval(parse(text = paste("volunteersDateCSVRemove <- volunteersDateCSVRemove %>% ",
        "mutate(", first, second, " = ", first, " +", second, ")",
        "%>% select(- c(", first, ", ", second, "))",
        sep = ""
  )))


sort(colnames(volunteersDateCSVRemove))




write.csv(volunteersDateCSVRemove, "volunteersDateCSVRemove.csv")





#competition 1
xmin <- as.Date("2020-07-24")
xmax <- as.Date("2020-07-31")

competition1 <- ifelse( xmin <= volunteersDateCSVRemove$Date &
                          volunteersDateCSVRemove$Date <= xmax, 1, 0)

#competition 2
xmin2 <- as.Date("2020-08-14")
xmax2 <- as.Date("2020-08-21")

competition2 <- ifelse( xmin2 <= volunteersDateCSVRemove$Date &
                          volunteersDateCSVRemove$Date <= xmax2, 1, 0)

#competition 3
xmin3 <- as.Date("2020-08-25")
xmax3 <- as.Date("2020-09-01")


competition3 <- ifelse( xmin3 <= volunteersDateCSVRemove$Date &
                          volunteersDateCSVRemove$Date <= xmax3, 1, 0)



#competition 4
xmin4 <- as.Date("2020-09-03")
xmax4 <- as.Date("2020-09-09")


competition4 <- ifelse( xmin4 <= volunteersDateCSVRemove$Date &
                          volunteersDateCSVRemove$Date <= xmax4, 1, 0)

competition <- competition1 + competition2 + competition3 + competition4 
competitionsStarted <- c(rep(0,15),rep(1,45))

daysOfProject <- seq(1:60)


daysFromAnnouncement <- ifelse(competition1 == 1, cumsum(competition1), 
            ifelse(
              competition2 == 1, cumsum(competition2),
                  ifelse(competition3 == 1, cumsum(competition3),
                              ifelse(competition4 == 1, cumsum(competition4),0)
                         )
            )
      )

cbind(competition,daysFromAnnouncement)



daysToDeadline <- ifelse(competition1 == 1, revcumsum(competition1), 
                               ifelse(
                                 competition2 == 1, revcumsum(competition2),
                                 ifelse(competition3 == 1, revcumsum(competition3),
                                        ifelse(competition4 == 1, revcumsum(competition4),0)
                                 )
                               )
)

cbind(competition,daysFromAnnouncement, daysToDeadline)



cbind(competition, competition1)

daysAfterDeadline <- c(rep(0,23),1:10,rep(0, sum(competition2)), 1:3, 
  rep(0,sum(competition3)),1, rep(0, sum(competition4)))

break1 <- 24:33
break2 <- 42:44
break3 <- 53

cbind(competition,daysAfterDeadline)

volunteersDateCSVRemove

weekday <- factor(weekdays(volunteersDateCSVRemove$Date),levels = c("Monday", "Tuesday", "Wednesday", 
                                                         "Thursday", "Friday", "Saturday", "Sunday"))



volunteersCompetition <- cbind(volunteersDateCSVRemove, competition1, 
                               competition2, 
                          competition3, competition4, competition,competitionsStarted,
                          daysFromAnnouncement, daysToDeadline,daysAfterDeadline, daysOfProject, weekday)


colnames(volunteersCompetition)

saveRDS(volunteersCompetition,"datasets/volunteersCompetition.rds")



#check if we need AR1 and what sort of arimas make sense
# colnames(volunteersCompetition)
# 
# bareArimas <- list()
# for (i in 2:27){
#   bareArimas[[i-1]] <- auto.arima(volunteersCompetition[,i],stationary=TRUE)
# }
# #it seems not; let's add lag 1 just in case once we split by users
# 


volunteersLong <- reshape2::melt(volunteersCompetition, measure.vars = 2:19, variable.name = "volunteer")

colnames(volunteersLong)[colnames(volunteersLong) == "value"] <- "interventions"


head(volunteersLong)

nrow(volunteersLong)

volunteersLong <- volunteersLong[volunteersLong$volunteer != "Patrycja",]

volunteersLong <- volunteersLong[!(volunteersLong$Date < "2020-07-17" &
                                     volunteersLong$volunteer == "bonusbgc"),]


volunteersLong <- volunteersLong[!(volunteersLong$Date < "2020-07-21" &
                                     volunteersLong$volunteer == "Hmkyna"),]

volunteersLong <- volunteersLong[!(volunteersLong$Date < "2020-08-02" &
                                     volunteersLong$volunteer == "Kawaii_Potato11"),]


volunteersLong <-  volunteersLong[volunteersLong$volunteer != "double.intervention",]

volunteersLong <-  volunteersLong[volunteersLong$volunteer != "someone",]



write_csv(volunteersLong, "volunteersLong.csv")


# #let's see what's going on
# 
# ggplot(volunteersLong)+geom_line(aes(x = Date, y = interventions, color = volunteer))
# 
# colnames(volunteersCompetition)
# 
# users <- colnames(cbind(volunteersCompetition[2:19],volunteersCompetition[21:27]) )
# sums <- colSums(cbind(volunteersCompetition[2:19],volunteersCompetition[21:27]))
# 
# length(sums)
# 
# str(users)
# 
# ggplot()+geom_bar(aes(x = reorder(users, sums), y = sums), stat = "identity")+
#   coord_flip()+theme_tufte()+ylab("total interventions")+xlab("")+
#   ggtitle("Volunteer engagement over 60 days")
# 


uniqueVolunteers <- as.character(unique(volunteersLong$volunteer))

uniqueVolunteers



volunteersSeparate <- list()
for(volunteer in 1:length(uniqueVolunteers)){
volunteersSeparate[[volunteer]] <-  volunteersLong[uniqueVolunteers[volunteer] ==
                                                     volunteersLong$volunteer,] 
}







#adding lags
for(volunteer in 1:length(uniqueVolunteers)){
  volunteersSeparate[[volunteer]]$interventionsL1 <-  
    lag(volunteersSeparate[[volunteer]]$interventions, 1, na.pad = TRUE) 
  volunteersSeparate[[volunteer]]$interventionsL1 <- 
    replace_na(volunteersSeparate[[volunteer]]$interventionsL1, 0)

  volunteersSeparate[[volunteer]][,2:10] <-
           sapply(volunteersSeparate[[volunteer]][,2:10],as.integer)
}



i <- 12
cbind(volunteersSeparate[[i]]$interventions,volunteersSeparate[[i]]$interventionsL1)

str(volunteersSeparate[[i]])

saveRDS(volunteersSeparate, "datasets/volunteersSeparate.rds")


volunteersJoint <- rbindlist(volunteersSeparate, fill=FALSE, idcol=NULL)

volunteersJoint$volunteer <- droplevels(volunteersJoint$volunteer)
str(volunteersJoint$volunteer)


volunteersJoint$volunteerID <- as.integer(volunteersJoint$volunteer)

head(volunteersJoint)


saveRDS(volunteersJoint,"datasets/volunteersJoint.rds")


volunteerDat <- list(
  N = nrow(volunteersJoint),
  U = length(unique(volunteersJoint$volunteerID)),
  weekday = as.integer(volunteersJoint$weekday), 
  competition1 = volunteersJoint$competition1,
  competition2 = volunteersJoint$competition2,
  competition3 = volunteersJoint$competition3,
  competition4 = volunteersJoint$competition4,
  competition = volunteersJoint$competition,
  competitionStarted = volunteersJoint$competitionsStarted,
  daysFromAnnouncement = volunteersJoint$daysFromAnnouncement,
  daysToDeadline = volunteersJoint$daysToDeadline,
  daysAfterDeadline = volunteersJoint$daysAfterDeadline,
  daysOfProject = volunteersJoint$daysOfProject,
  daysOfProjectSquared = volunteersJoint$daysOfProject^2,
  daysOfProjectInverse = 1/volunteersJoint$daysOfProject,
  volunteerID = volunteersJoint$volunteerID,
  interventions = volunteersJoint$interventions,
  interventionsL1 = volunteersJoint$interventionsL1
)

str(volunteerDat)  


saveRDS(volunteerDat,"datasets/volunteerDat.rds")
