library(data.table)
library(tidyverse)
library(ggplot2)
library(scales)
library(dplyr)
library(janitor)


# #setwd("~/Desktop/nestaVolunteers")
# 
# volunteers <- read.csv(file = "volunteers.csv")
# 
# head(volunteers, n = 20)
# nrow(volunteers) #1755
# 
# #remove empty rows
# 
# volunteersCleaned <- volunteers[!apply(volunteers == "", 1, all), ] 
# 
# nrow(volunteersCleaned)
# head(volunteersCleaned)
# 
# #now I want to convert the format and have one day as one variable and count of interventions per day
# 
# 
# volunteersDate <- t(xtabs(~Volunteer.name + Date, data=volunteersCleaned))
# 
# head(volunteersDate)
# ncol(volunteersDate)
# nrow(volunteersDate)
# str(volunteersDate)
# 
# write.csv(volunteersDate, "volunteersDate.csv")
# 
# #I had to write and read csv to get rid of the xtabs format
# volunteersDateCSV <- read.csv(file = "volunteersDate.csv")
# 
# 
# head(volunteersDateCSV)
# str(volunteersDateCSV)
# 
# #removing first column and first row
# volunteersDateCSVRemove <- volunteersDateCSV[,-2]
# head(volunteersDateCSVRemove)
# nrow(volunteersDateCSVRemove)
# 
# colnames(volunteersDateCSVRemove)[1] <- "Date"
# 
# str(volunteersDateCSVRemove)
# 
# volunteersDateCSVRemove$Date <- as.Date(volunteersDateCSVRemove$Date)
# 
# 
# #competition 1
# xmin <- as.Date("2020-07-24")
# xmax <- as.Date("2020-07-31")
# 
# competition1 <- ifelse( xmin <= volunteersDateCSVRemove$Date &
#                           volunteersDateCSVRemove$Date <= xmax, 1, 0)
# 
# #competition 2
# xmin2 <- as.Date("2020-08-14")
# xmax2 <- as.Date("2020-08-21")
# 
# competition2 <- ifelse( xmin2 <= volunteersDateCSVRemove$Date &
#                           volunteersDateCSVRemove$Date <= xmax2, 1, 0)
# 
# #competition 3
# xmin3 <- as.Date("2020-08-25")
# xmax3 <- as.Date("2020-09-01")
# 
# 
# competition3 <- ifelse( xmin3 <= volunteersDateCSVRemove$Date &
#                           volunteersDateCSVRemove$Date <= xmax3, 1, 0)
# 
# 
# 
# #competition 4
# xmin4 <- as.Date("2020-09-03")
# xmax4 <- as.Date("2020-09-09")
# 
# 
# competition4 <- ifelse( xmin4 <= volunteersDateCSVRemove$Date &
#                           volunteersDateCSVRemove$Date <= xmax4, 1, 0)
# 
# 
# 
# volunteersCompetition <- cbind(volunteersDateCSVRemove, competition1, 
#                                competition2, 
#                           competition3, competition4)
# 
# 
# head(volunteersCompetition)
# 
# 
# 
# 
# 
# 
# 
# #extract sums of columns
# volunteerDateSum <- volunteersDateCSVRemove %>%                       
#   replace(is.na(.), 0) %>%
#   summarise_all(sum)
# 
# head(volunteerDateSum)
# ncol(volunteerDateSum)
# 
# byDaySum <- write.csv(volunteerDateSum, "byDaySum.csv")
# 
# #now, some days are missing, it means there were no interventions that day. 6,7,9.08. Let's add them with value of 0.
# volunteerDateSum1 <- add_column(volunteerDateSum, X2020.08.06 = 0, .after = "X2020.08.05")
# volunteerDateSum2 <- add_column(volunteerDateSum1, X2020.08.07 = 0, .after = "X2020.08.06")
# volunteerDateSum3 <- add_column(volunteerDateSum2, X2020.08.09 = 0, .after = "X2020.08.08")
# 
# head(volunteerDateSum3)
# 
# #now in order to make time series graph I need to switch the format from wide to long
# dataLong <- gather(volunteerDateSum3, date, number, X2020.07.09:X2020.09.09)
# str(dataLong$date)
# str(dataLong$number)
# dataLong
# 
# #Let's remove the X that at some point occured in our dates
# 
# dataLong$date <- sub("X", "", dataLong$date)
# 
# dataLong
# 
# #now converting date as Date, now it's a character
# 
# dataLong$date <- as.Date(dataLong$date, tryFormats = c("%Y.%m.%d"),
#         optional = FALSE)
# dataLong
# 
# str(dataLong$date) #YEAH BABY
# 
# #writeCSV
# completeSummary <- write.csv(dataLong, "completeSummary.csv")
# 
# 
# 
# 
# #time series graph
# p <- ggplot(dataLong, aes(x=date, y=number)) +
#   geom_line() + 
#   xlab("") + 
#   scale_x_date(date_labels = "%Y %b %d")
# p
# 
# 
#time series graph with marked periods of contests



 


volunteersJoint <- readRDS("datasets/volunteersJoint.rds")



xmin <- as.Date("2020-07-24")
xmax <- as.Date("2020-07-31")
xmin2 <- as.Date("2020-08-14")
xmax2 <- as.Date("2020-08-21")
xmin3 <- as.Date("2020-08-25")
xmax3 <- as.Date("2020-09-01")
xmin4 <- as.Date("2020-09-03")
xmax4 <- as.Date("2020-09-09")




head(volunteersJoint)

colnames(volunteersJoint)



ggplot(volunteersJoint)+ geom_point(aes(x = Date, y = interventions))+
  scale_x_date(date_labels = "%Y %b %d") +
  xlab("") +
  geom_rect(aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  labs(subtitle = "With contest periods") +
  geom_rect(aes(xmin = xmin2, xmax = xmax2, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin3, xmax = xmax3, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin4, xmax = xmax4, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1)+theme_tufte()




r <- ggplot(dataLong, aes(x=date, y=number)) +
  geom_line() + 
  scale_x_date(date_labels = "%Y %b %d") +
  xlab("") +
  geom_rect(aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, 
              alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "marked are periods of weekly contests", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin2, xmax = xmax2, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin3, xmax = xmax3, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin4, xmax = xmax4, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1)
r

#try geom_step


#ordered bar chart
ggplot(dataLong, aes(x=date, y=number)) + 
  geom_bar(stat = "identity", width=.7, fill="grey") + 
  labs(title="Volunteers engagement: number of interventions conducted per day", 
       subtitle="From July 9th until September 9th. Marked are periods of contests.", 
       caption="") + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
  geom_rect(aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin2, xmax = xmax2, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin3, xmax = xmax3, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1) +
  geom_rect(aes(xmin = xmin4, xmax = xmax4, ymin = -Inf, ymax = Inf, 
                alpha = I(.05), fill  = I("lightblue"))) +
  annotate("text", label = "", x = xmin, y = Inf, angle = 90,
           hjust = 1.1, vjust = -1)




