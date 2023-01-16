library(data.table)
library(tidyverse)
library(ggplot2)
library(scales)
library(dplyr)
library(janitor)
library(spatstat.utils)
library(useful)
library(ggthemes)
library(tidyquant)
library(gridExtra)


volunteersLong <- read_csv(file = "volunteersLong.csv")
volunteersSeparate <- readRDS(file =  "datasets/volunteersSeparate.rds")
volunteersJoint <- readRDS( file = "datasets/volunteersJoint.rds")
competitionModel<- readRDS( "competitionModel.rds")




plotVolunteer <- function(i){
  ggplot(volunteersSeparate[[i]])+geom_point(aes(x = Date, y = interventions, color = as.factor(competition), size = interventions), alpha = .8)+
    theme_tufte(base_size = 7)+
    scale_color_manual(values = c("orangered", "grey"), labels = c("yes", "no"), name = "competition", breaks = c("1", "0"))+xlab("")+
    theme(plot.title.position = "plot",legend.position = c(0.09, 0.9), legend.key.size = unit(.25, "cm") )+ 
    scale_size(range = c(.5,2))+guides(size = "none")+ggtitle(paste("Interventions of volunteer", i, sep = " "))
}



#volunteersSeparate <- readRDS("datasets/volunteersSeparate.rds")
#volunteersCompetition <- readRDS("datasets/volunteersCompetition.rds")


# #low rarely, none otherwise
# plotVolunteer(1) #low
# plotVolunteer(2)  #low
# plotVolunteer(3) #low
# plotVolunteer(4) #low
# plotVolunteer(5) #initial
# plotVolunteer(6) #initial
# plotVolunteer(7) #initial
# plotVolunteer(8) #selective
# plotVolunteer(9) #dynamic
# plotVolunteer(10) #initial
# plotVolunteer(11) #selective
# plotVolunteer(12) #selective
# plotVolunteer(13) #dynamic
# plotVolunteer(14) #dynamic
# plotVolunteer(15) #selective



profile <- c("low", "low", "low", "low",
             "initial", "initial", "initial",  "selective",
             "dynamic", "initial","selective","selective",
             "dynamic","dynamic", "selective")



volunteers <- unique(volunteersJoint$volunteer)
volunteersIDs <- unique(volunteersJoint$volunteerID)

volunteersSummary <- volunteersJoint %>%
  group_by(volunteer) %>%
  summarise(totalActivity = sum(interventions))


volunteers == volunteersSummary$volunteer

volunteersSummary$volunteerID <- as.factor(volunteersIDs)


str(volunteersSummary)

volunteersSummary$profile <- factor(profile, levels = c("dynamic","active", "selective", "initial", "low"))

volunteersSummary <- as.data.frame(volunteersSummary)

volunteersSummary

                                    
                                    
meanRunning <- volunteersJoint  %>%
  group_by(Date) %>%
  summarise(competition = mean(competition), meanInterventions = mean(interventions))


meanRunning

beginning <- meanRunning$Date < "2020-07-16"

volunteersDailyMeansPlot <- ggplot(data = meanRunning)+ 
  geom_violin(aes(x= as.factor(competition), y = meanInterventions,
                  color = as.factor(competition)))+
  theme_tufte(base_size = 10)+xlab("competition")+
  ylab("mean daily interventions")+
  ggtitle("Daily intervention means were higher during competitions")+
  geom_jitter(width = .3, aes(x= as.factor(competition),
              y = meanInterventions, 
              color =  as.factor(competition), shape = meanRunning$Date < "2020-07-16",
              size = meanInterventions)
              , alpha = .6)+
  theme(plot.title.position = "plot",legend.position = c(0.09, 0.85) )+
  scale_size(range = c(1,4))+guides(size = "none", color = "none")+
  scale_color_manual(values = c("orangered", "grey"),
                     labels = c("yes", "no"), name = "competition",
                     breaks = c("1", "0"))+
  guides(shape = guide_legend(title = "First week"))



meanRunning$Date < "2020-07-16"

volunteersDailyMeansPlot


voluteerDailyPlot <- ggplot(volunteersJoint)+geom_point(aes(x = Date, y = interventions, color = as.factor(competition), size = interventions), alpha = .8)+
  theme_tufte(base_size = 7)+
  scale_color_manual(values = c("orangered", "grey"), labels = c("yes", "no"), name = "competition", breaks = c("1", "0"))+xlab("")+
  theme(plot.title.position = "plot",legend.position = c(0.09, 0.9), legend.key.size = unit(.25, "cm") )+ 
  scale_size(range = c(.5,2))+guides(size = "none")+labs(title = "After initial enthusiasm, volunteer engagement was higher during competitions")+ 
  geom_line(data = meanRunning, aes(x = Date, y = meanInterventions))



voluteerDailyPlot 


#sums and profiles
#sumsPlot <-
  

sumsPlot  <- ggplot(volunteersSummary) +geom_bar(aes(x = reorder(as.factor(volunteerID), totalActivity)
                                        , y = totalActivity, fill = profile), stat = "identity")+
  coord_flip()+theme_tufte(base_size = 10)+ylab("total interventions")+xlab("")+
  ggtitle("Volunteer total engagement over 60 days")+
  scale_fill_manual(values = c("darkred", "orangered", "darkgoldenrod", "bisque2", "azure4"),
                    labels = c("active, more during competitions","active throughout" , "active only during competitions", "initial enthusiasm died", "almost no activity"))+
  theme(plot.title.position = "plot", legend.key.size = unit(.4, "cm"),legend.position = c(.55, 0.3) )+xlab("volunteer ID")


sumsPlot 



precis <- precis(competitionModel, depth = 2)
lIndividual <- precis[grep("l\\[",rownames(precis)),]
lGroup <- exp(precis[grep("lbar",rownames(precis)),])


lmean <- exp(lIndividual$mean)
llow <- exp(lIndividual$`5.5%`)
lhigh <- exp(lIndividual$`94.5%`)

eIndividual <- precis[grep("enth\\[",rownames(precis)),]
enthmean <- exp(eIndividual$mean)
enthlow <- exp(eIndividual$`5.5%`)
enthhigh <- exp(eIndividual$`94.5%`)

eGroup <- exp(precis[grep("enthbar",rownames(precis)),])

precis

cIndividual <- precis[grep("comp\\[",rownames(precis)),]
cmean <- exp(cIndividual$mean)
clow <- exp(cIndividual$`5.5%`)
chigh <- exp(cIndividual$`94.5%`)

cGroup <- exp(precis[grep("compbar",rownames(precis)),])

as.integer(as.factor(profile))

volunteersDF <- data.frame(volunteer = volunteers, totalActivity = 
                             volunteersSummary$totalActivity ,
          profile = volunteersSummary$profile , 
          profileID = as.integer(volunteersSummary$profile ),
           volunteerID = as.integer(as.factor(volunteers)),
           lmean = lmean, llow = llow, lhigh = lhigh,
           emean = enthmean, elow = enthlow, ehigh = enthhigh,
           cmean = cmean, clow = clow, chigh = chigh)



sumsPlot


volunteersDF


lambdaPlot


lambdaPlot <- ggplot(volunteersDF)+geom_pointrange(aes(x = reorder(as.factor(volunteerID), totalActivity),y = lmean, ymin  = llow, ymax = lhigh,
                                                       color = profile))+
coord_flip()+theme_tufte(base_size = 10)+xlab("")+ylab(expression(lambda))+theme(axis.text.y =
                element_blank(), axis.ticks.y = element_blank())+ggtitle("Daily baseline")+
  scale_color_manual(values = c("darkred", "orangered", "darkgoldenrod", "bisque2", "azure4"),
                    labels = c("active, more during competitions","active throughout" , 
                               "active only during competitions", "initial enthusiasm died", "almost no activity"))+
  guides(color = "none")+geom_hline(yintercept = lGroup$mean, alpha = .8)+
  annotate("rect", ymin = lGroup$`5.5%`, ymax = lGroup$`94.5%`,
           xmin = 0, xmax = 16.5,
           alpha = .2,fill = "grey")+
  annotate("label", label =  round(lGroup$mean,2), y = lGroup$mean, x = 16)

lambdaPlot


enthusiasmPlot <- ggplot(volunteersDF)+geom_pointrange(aes(x = reorder(as.factor(volunteerID), totalActivity),y = emean, ymin  = elow, ymax = ehigh,
                                                       color = profile))+
  coord_flip()+theme_tufte(base_size = 10)+xlab("")+ylab("multiplier per day passed")+theme(axis.text.y =
                                                                       element_blank(), axis.ticks.y = element_blank())+
  ggtitle("Enthusiasm change per day")+
  scale_color_manual(values = c("darkred", "orangered", "darkgoldenrod", "bisque2", "azure4"),
                     labels = c("active, more during competitions","active throughout" , 
                                "active only during competitions", "initial enthusiasm died", "almost no activity"))+
  guides(color = "none")+geom_hline(yintercept = 1, alpha = .6, color = "grey", lty = 2)+
  geom_hline(yintercept = eGroup$mean, alpha = .9)+
  annotate("rect", ymin = eGroup$`5.5%`, ymax = eGroup$`94.5%`,
           xmin = 0, xmax = 16.5,
           alpha = .2,fill = "grey")+
  annotate("label", label =  round(eGroup$mean,2), y = eGroup$mean, x = 16)


enthusiasmPlot


competitionPlot <- ggplot(volunteersDF)+geom_pointrange(aes(x = reorder(as.factor(volunteerID), totalActivity),y = cmean, ymin  = clow, ymax = chigh,
                                                           color = profile))+
  coord_flip()+theme_tufte(base_size = 10)+xlab("")+ylab("multiplier if competition is on")+theme(axis.text.y =
                                                                                element_blank(), axis.ticks.y = element_blank())+
  ggtitle("Impact of competitions")+
  scale_color_manual(values = c("darkred", "orangered", "darkgoldenrod", "bisque2", "azure4"),
                     labels = c("active, more during competitions","active throughout" , 
                                "active only during competitions", "initial enthusiasm died", "almost no activity"))+
  guides(color = "none")+geom_hline(yintercept = 1, alpha = .6, color = "grey", lty = 2)+
  geom_hline(yintercept = cGroup$mean, alpha = .9)+
  annotate("rect", ymin = cGroup$`5.5%`, ymax = cGroup$`94.5%`,
           xmin = 0, xmax = 16.5,
           alpha = .2,fill = "grey")+
  annotate("label", label =  round(cGroup$mean,2), y = cGroup$mean, x = 16)


competitionPlot


sumsPlotGrob <- ggplotGrob(sumsPlot)
lambdaPlotGrob <- ggplotGrob(lambdaPlot)
enthusiasmPlotGrob <- ggplotGrob(enthusiasmPlot)
competitionPlotGrob <- ggplotGrob(competitionPlot)


#volunteersJointPlot <- 
  
ggplot(data.frame(a=1)) + xlim(1, 38) + ylim(1, 10)+theme_void()+
annotation_custom(sumsPlotGrob, xmin = 1, xmax = 10, ymin =1.2, ymax = 9.56)+
annotation_custom(lambdaPlotGrob, xmin = 10, xmax = 20, ymin =1, ymax = 10)+
annotation_custom(enthusiasmPlotGrob, xmin = 18, xmax = 28, ymin = 1, ymax = 10)+
annotation_custom(competitionPlotGrob, xmin = 28.5, xmax = 38.5, ymin =1, ymax = 10)




