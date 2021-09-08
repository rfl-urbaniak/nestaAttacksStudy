library(ggplot2)
library(ggthemes)


getwd()
Hate <- readRDS(file = "datasets/RAWNESTA/Hate.rds")
Comments <-   readRDS(file = "datasets/RAWNESTA/Comments.rds")


dates <- colnames(Hate)[-1]
dates <- as.Date(dates)



startDate <- dates[1]
interventionDate <- "2020-07-08"
observationDate <- "2020-09-09"
end <- dates[length(dates)]

periods<- numeric(length(dates))
periods <- ifelse(dates < interventionDate,"pre-treatment",periods)
periods <- ifelse(dates >= interventionDate & dates < observationDate,"treatment",periods)
periods <- ifelse(dates >= observationDate,"post-treatment",periods)
periods



length(periods)
length(dates)



hateTS <- as.data.frame(colSums(Hate[,-1]))
hateTS$date <- as.Date(rownames(hateTS))
rownames(hateTS) <- NULL
colnames(hateTS) <- c("attacks","date")
head(hateTS)
hateTS$periods <- periods


interventions <- readRDS(file = "datasets/interventions.rds")

interventionsTS <- as.data.frame(table(interventions$day))

interventionsTS$Var1 <- as.Date(interventionsTS$Var1)

colnames(interventionsTS) <- c("date", "interventions")

interventionsTS

periodsDF <- merge(x = hateTS, y = interventionsTS, by = "date", all.x = TRUE)

idx <- c(1, diff(periodsDF$date))
i2 <- c(1,which(idx != 1), nrow(periodsDF)+1)
periodsDF$grp <- rep(1:length(diff(i2)), diff(i2))

periodsDF$interventions[is.na(periodsDF$interventions) & periodsDF$periods == "treatment"] <- 0

periodsDF

ggplot(periodsDF)+
  geom_line(aes(x=date, y = attacks, group = grp),
             alpha = 0.8, size = .6)+
  geom_line(aes(x=date, y = interventions, group = grp),
            alpha = 0.8, size = .6)+
  geom_vline(xintercept = startDate, lty =2, size =.2, alpha=0.5)+
  geom_vline(xintercept = as.Date(interventionDate), lty =2, size =.2, alpha=0.5)+
  geom_vline(xintercept =  as.Date(observationDate), lty = 2, size =.2, alpha=0.5 )+
  geom_vline(xintercept = as.Date(end), lty =2, size =.2, alpha=0.5)+
  labs(title = "Attacks and interventions time series", subtitle = "no line at data gaps", 
       caption = "days with data: 81 (pre-treatment), 62 (treatment), 72 (post-treatment)")+
  theme_tufte() + theme(axis.title.x=element_blank(), 
      plot.caption = element_text(hjust = 0.5,  face= "italic"))+
  #  scale_x_date(date_labels = "%b %d",date_breaks = "2 weeks", limits = c(startDate-10,end+10))+
  scale_x_date(date_labels = "%b %d", breaks = c(startDate, as.Date(startDate), as.Date(interventionDate), as.Date(observationDate), end), 
               limits = c(startDate-30,end+10))+ylab("count")+
  annotate("rect", xmin = as.Date(interventionDate), xmax = as.Date(observationDate), ymin = -1, ymax = 360,
           alpha = .2,fill = "darkgreen")+ylim(c(-1,370))+
  annotate("text", label = "pre-treatment", x = as.Date(startDate)+2, y = 370, hjust =0 )+
  annotate("text", label = "treatment", x = as.Date(interventionDate)+2, y = 370, hjust =0 )+
  annotate("text", label = "post-treatment", x = as.Date(observationDate)+2, y = 370, hjust =0 )+
  annotate("text", label = "interventions:", x = as.Date(interventionDate)-47, y = 15, hjust =0 )+
  annotate("text", label = "attacks:", x = as.Date(startDate)-30, y = 215, hjust =0 )








periodsDF

dateDF



periods <- ggplot(dateDF, aes(x=dates, y = points, color = periods, group = grp))+geom_line(alpha = 0.8, size = 1)+theme_tufte()+ theme(axis.title.y=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),axis.title.x=element_blank(), plot.caption = element_text(hjust = 0.5,  face= "italic"))+
#  scale_x_date(date_labels = "%b %d",date_breaks = "2 weeks", limits = c(startDate-10,end+10))+
  scale_x_date(date_labels = "%b %d", breaks = c(startDate, as.Date(startDate), 
          as.Date(interventionDate), as.Date(observationDate), end), limits = c(startDate-10,end+10))+
  geom_vline(xintercept = dates[which(dates == startDate)], lty =2, size =.2, alpha=0.5)+
  geom_vline(xintercept = dates[which(dates == interventionDate)], lty= 2, size = .2, alpha=0.5)+
  geom_vline(xintercept = dates[which(dates == observationDate)], lty = 2, size =.2, alpha=0.5 )+ylim(c(0.95,1.05))+ geom_vline(xintercept = as.Date(end), lty =2, size =.2, alpha=0.5)+
  labs(title = "Data collection periods", subtitle = "no line at data gaps", caption = "days with data: 81 (pre-treatment), 62 (treatment), 72 (post-treatment)")+
  scale_color_discrete(breaks=c("pre-treatment", "treatment", "post-treatment"))

ggsave("images/periods.pdf", width = 20, height = 6, units = "cm", dpi = 450)  

  

table(periods)



#time series of interventions
#and hate

interventions <- readRDS(file = "datasets/interventions.rds")


head(interventions)

interventionsTS <- as.data.frame(table(interventions$day))

interventionsTS$Var1 <- as.Date(interventionsTS$Var1)

head(Hate)


hateRestrTS <- hateTS[hateTS$date >= min(interventionsTS$Var1) &
                        hateTS$date <=max(interventionsTS$Var1),]


intInTimePlot <- ggplot() +
  geom_line(data = interventionsTS,aes(x = Var1, y = Freq, lty = "interventions"))+
  geom_line(data = hateRestrTS,aes(x = date, y = count, lty = "attacks"))+
  theme_tufte(base_size = 10)+xlab("")+ylab("count") +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank(),
        legend.title=element_blank())+ylim(c(0,220))

intInTimePlot

periods+ylim(c(0.995,1.06))+ 
  annotation_custom(ggplotGrob(intInTimePlot), 
  xmin = as.Date(interventionDate)-19, xmax = as.Date(observationDate)+4,ymin=1, ymax=1.06)

                            
                            
ggsave("images/periodsWithInterventions.pdf", width = 20, height = 10, units = "cm", dpi = 450)  



