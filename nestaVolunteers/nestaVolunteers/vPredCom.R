library(rethinking)
library(ggplot2)
library(data.table)
library(tidyverse)
library(scales)
library(dplyr)
library(janitor)
library(spatstat.utils)
library(useful)
library(ggthemes)



volunteersSeparate <- readRDS("datasets/volunteersSeparate.rds")
volunteersJoint <- rbindlist(volunteersSeparate, fill=FALSE, idcol=NULL)
volunteersCompetition <- readRDS("datasets/volunteersCompetition.rds")


users <- colnames(cbind(volunteersCompetition[2:19],volunteersCompetition[21:27]) )
sums <- colSums(cbind(volunteersCompetition[2:19],volunteersCompetition[21:27]))





plotVolunteer <- function(i){
ggplot(volunteersSeparate[[i]])+geom_point(aes(x = Date, y = interventions, color = as.factor(competition), size = interventions), alpha = .8)+
  theme_tufte(base_size = 7)+
  scale_color_manual(values = c("orangered", "grey"), labels = c("yes", "no"), name = "competition", breaks = c("1", "0"))+xlab("")+
  theme(plot.title.position = "plot",legend.position = c(0.09, 0.9), legend.key.size = unit(.25, "cm") )+ 
  scale_size(range = c(.5,2))+guides(size = "none")+ggtitle(paste("Interventions of volunteer", i, sep = " "))
}

profile <- c("low", "low", "low", "initial", "initial", 
             "low", "low", "low", "dynamic","initial",
             "low","initial","initial","low","dynamic",
             "selective", "active","initial", "selective", "selective",
             "active", "selective", "selective", "initial",
             "active")

#low rarely, none otherwise
plotVolunteer(1) #low
plotVolunteer(2)  #low
plotVolunteer(3) #low
plotVolunteer(4) #initial
plotVolunteer(5) #initial
plotVolunteer(6) #low
plotVolunteer(7) #low
plotVolunteer(8) #low
plotVolunteer(9) #dynamic
plotVolunteer(10) #initial
plotVolunteer(11) #low
plotVolunteer(12) #initial
plotVolunteer(13) #initial
plotVolunteer(14) #low
plotVolunteer(15) #dynamic
plotVolunteer(16)  #selective
plotVolunteer(17)  #active
plotVolunteer(18) #initial
plotVolunteer(19)   #selective
plotVolunteer(20)  #selective
plotVolunteer(21)  #active
plotVolunteer(22)  #selective
plotVolunteer(23)  #selective
plotVolunteer(24) #initial
plotVolunteer(25) #active

#active, more during competitions


#active only during competition


#just active


profile <- factor(profile, levels = c("dynamic","active", "selective", "initial", "low"))


sums

length(profile)

ggplot()+geom_bar(aes(x = reorder(users, sums), y = sums, fill = profile), stat = "identity")+
  coord_flip()+theme_tufte()+ylab("total interventions")+xlab("")+
  ggtitle("Volunteer engagement over 60 days")+
  scale_fill_manual(values = c("darkred", "orangered", "darkgoldenrod", "bisque2", "azure4"),
    labels = c("active, more during competitions","active throughout" , "active only during competitions", "initial enthusiasm died", "almost no activity"))+
  theme(plot.title.position = "plot",legend.position = c(.55, 0.3), legend.key.size = unit(.4, "cm") )













