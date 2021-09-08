library(ggplot2)
library(ggthemes)


getwd()
Hate <- readRDS(file = "datasets/RAWNESTA/Hate.rds")
Comments <-   readRDS(file = "datasets/RAWNESTA/Comments.rds")


dates <- colnames(Hate)[-1]
dates <- as.Date(dates)



startDate <- dates[1]
interventionDate <- "2020-07-09"
observationDate <- "2020-09-10"
end <- dates[length(dates)]

periods<- numeric(length(dates))
periods <- ifelse(dates < interventionDate,"pre-treatment",periods)
periods <- ifelse(dates >= interventionDate & dates < observationDate,"treatment",periods)
periods <- ifelse(dates >= observationDate,"post-treatment",periods)
periods


length(periods)
length(dates)

points <- rep(1,length(dates))


dateDF <- data.frame(dates,periods, points)


idx <- c(1, diff(dateDF$dates))
i2 <- c(1,which(idx != 1), nrow(dateDF)+1)
dateDF$grp <- rep(1:length(diff(i2)), diff(i2))

dateDF



periods <- ggplot(dateDF, aes(x=dates, y = points, color = periods, group = grp))+geom_line(alpha = 0.8, size = 1)+theme_tufte()+ theme(axis.title.y=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),axis.title.x=element_blank(), plot.caption = element_text(hjust = 0.5,  face= "italic"))+
#  scale_x_date(date_labels = "%b %d",date_breaks = "2 weeks", limits = c(startDate-10,end+10))+
  scale_x_date(date_labels = "%b %d", breaks = c(startDate, as.Date(startDate), as.Date(interventionDate), as.Date(observationDate), end), limits = c(startDate-10,end+10))+
  geom_vline(xintercept = dates[which(dates == startDate)], lty =2, size =.2, alpha=0.5)+
  geom_vline(xintercept = dates[which(dates == interventionDate)], lty= 2, size = .2, alpha=0.5)+
  geom_vline(xintercept = dates[which(dates == observationDate)], lty = 2, size =.2, alpha=0.5 )+ylim(c(0.95,1.05))+ geom_vline(xintercept = as.Date(end), lty =2, size =.2, alpha=0.5)+
  labs(title = "Data collection periods", subtitle = "no line at data gaps", caption = "days with data: 81 (pre-treatment), 62 (treatment), 72 (post-treatment)")+
  scale_color_discrete(breaks=c("pre-treatment", "treatment", "post-treatment"))

ggsave("images/periods.pdf", width = 20, height = 6, units = "cm", dpi = 450)  

  

table(periods)



#time series of interventions

interventions <- readRDS(file = "datasets/interventions.rds")


head(interventions)

interventionsTS <- as.data.frame(table(interventions$day))

interventionsTS$Var1 <- as.Date(interventionsTS$Var1)

intInTimePlot <- ggplot(interventionsTS, aes(x = Var1, y = Freq)) +geom_line()+theme_tufte(base_size = 9)+xlab("")+ylab("daily interventions") + theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())

periods+ylim(c(0.995,1.06))+ annotation_custom(ggplotGrob(intInTimePlot), xmin = as.Date(interventionDate)-19, xmax = as.Date(observationDate)+4,ymin=1, ymax=1.06)
                            
                            
ggsave("images/periodsWithInterventions.pdf", width = 20, height = 10, units = "cm", dpi = 450)  



