library(ggplot2)
library(ggthemes)
library(ggpubr)

summaries <- readRDS(file = "datasets/Summaries.rds")


head(summaries)



# weekly averages
#days: 81 (pre-treatment), 62 (treatment), 72 (post-treatment)

head(summaries)
summaries$ABw <- (summaries$AB/81)*7
summaries$CBw <- (summaries$CB/81)*7
summaries$AAw <- (summaries$AB/72)*7
summaries$CAw <- (summaries$CB/72)*7

summaries$Adiffw <- summaries$AAw - summaries$ABw
summaries$Cdiffw <- summaries$CAw - summaries$CBw



mean(summaries$AAw)
mean(summaries$ABw)


#barplot of attacks

ggplot(summaries, aes(x = ABw, fill = "before"), alpha = 0.6, bins = 80)+geom_histogram()+theme_tufte() +geom_histogram(aes(x = AAw, fill = "after"), alpha = 0.6, bins = 80)+  xlab("attacks")+labs(title = "Attacks before & after", subtitle = "(weekly averages)")



ggplot(summaries, aes(x = Adiffw, fill = group), alpha = 0.6, bins = 160)+geom_density(alpha=0.3)

ggplot(summaries, aes(x = Adiffw, fill = group,  y = stat(count / sum(count))), alpha = 0.6, bins = 160)+geom_histogram()+theme_tufte()+  xlab("attacks")+labs(title = "Change in attacks", subtitle = "(weekly averages)")+facet_wrap(~group, ncol = 1)



ggplot()+theme_tufte() +geom_histogram(aes(x = ACprop, fill = summaries$group, y  = stat(count / sum(count)), group = summaries$group), alpha = 0.4, bins = 80)+  xlab("attacks")+labs(title = "Proportional change in attacks by group")+geom_vline(xintercept = 1, size = 0.2)+xlim(c(0,3))+ylim(c(0,.2))






#barplot of interventions
ggplot(summaries[summaries$group != "control",], aes(x = IC))+geom_bar()+theme_tufte()+
  xlab("interventions received")+labs(title = "Intervention counts in treatment groups")+
  scale_x_continuous(breaks = seq(0,40,5))

ggsave("images/interventionsBar.pdf", width = 20, height = 10, units = "cm", dpi = 450)  



ggplot(summaries, aes(x=AdiffS, fill = group))+geom_density(alpha= 0.3)+theme_tufte()+xlim(c(-1,1))

mean(summaries$AdiffS)


ReturnMax<-function(numvec){
  dens <- density(numvec)
  return(dens$x[which.max(dens$y)][1])
         }



maxControlS <- ReturnMax(summaries[summaries$group == "control",]$AdiffS)
maxEmpathyS <- ReturnMax(summaries[summaries$group == "empathy",]$AdiffS)
maxNormativeS <- ReturnMax(summaries[summaries$group == "normative",]$AdiffS)

densAdiffCS <- ggplot(summaries[summaries$group == "control",], aes(x=AdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxControlS, alpha = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Control")+xlab("standard deviation from the mean")

densAdiffES <- ggplot(summaries[summaries$group == "empathy",], aes(x=AdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxEmpathyS, alpha = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Empathy")+xlab("standard deviation from the mean")

densAdiffNS <-
  ggplot(summaries[summaries$group == "normative",], aes(x=AdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxNormativeS, alpha  = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Normative")+xlab("standard deviation from the mean")


densJoint <- ggarrange(densAdiffCS,densAdiffES, densAdiffNS, ncol = 1)

densJoint1 <- annotate_figure(densJoint, top = text_grob("(for visibility, range restricted to \u00B1 1 sd)",  size = 10))

annotate_figure(densJoint1, top = text_grob("Standardized difference in attacks (empirical distribution)", size = 12))

ggsave("images/ACS.pdf", width = 20, height = 15, units = "cm", dpi = 450)  



#now for comments

summaries


maxCControlS <- ReturnMax(summaries[summaries$group == "control",]$CdiffS)
maxCEmpathyS <- ReturnMax(summaries[summaries$group == "empathy",]$CdiffS)
maxCNormativeS <- ReturnMax(summaries[summaries$group == "normative",]$CdiffS)

densCdiffCS <- ggplot(summaries[summaries$group == "control",], aes(x=CdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxCControlS, alpha = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Control")+xlab("standard deviation from the mean")

densCdiffES <- ggplot(summaries[summaries$group == "empathy",], aes(x=CdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxCEmpathyS, alpha = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Empathy")+xlab("standard deviation from the mean")

densCdiffNS <-
  ggplot(summaries[summaries$group == "normative",], aes(x=CdiffS))+geom_density(alpha= 0.2)+theme_tufte()+xlim(c(-1,1))+geom_vline(xintercept = maxCNormativeS, alpha  = 0.3)+
  theme(axis.title.y=element_blank(), axis.text.y=element_blank(),axis.ticks.y=element_blank())+ggtitle("Normative")+xlab("standard deviation from the mean")


densJoint <- ggarrange(densCdiffCS,densCdiffES, densCdiffNS, ncol = 1)

densJoint1 <- annotate_figure(densJoint, top = text_grob("(for visibility, range restricted to \u00B1 1 sd)",  size = 10))

annotate_figure(densJoint1, top = text_grob("Standardized difference in comments (empirical distribution)", size = 12))



ggsave("images/CCS.pdf", width = 20, height = 15, units = "cm", dpi = 450)  



summaries[summaries$IC != 0,]

ggplot(summaries, aes(x = IC, y = AdiffS, color = group, fill = group))+geom_jitter(alpha = 0.6)+theme_tufte()+geom_smooth(alpha = 0.2, method = "lm")+xlim(c(0,20))+ylim(c(-1,1))


ggplot(summaries, aes(x = IC, y = Adiff, color = group, fill = group))+geom_jitter(alpha = 0.6)+theme_tufte()+geom_smooth(alpha = 0.2, method = "lm")+xlim(c(0,20))+ylim(c(-100,100))


ggplot(summaries, aes(x = IC, y = Adiff, color = group, fill = group))+geom_jitter(alpha = 0.6)+theme_tufte()+geom_smooth(alpha = 0.2, method = "lm")+xlim(c(0,20))+ylim(c(-50,50))

ggplot(summaries, aes(x = IC, y = Adiff, color = group, fill = group))+geom_jitter(alpha = 0.6)+theme_tufte()+geom_smooth(alpha = 0.2)+xlim(c(0,20))+ylim(c(-50,50))



ggplot(summaries, aes(x = IC, y = Adiff, color = group, fill = group))+geom_jitter(alpha = 0.6)+theme_tufte()+geom_smooth(alpha = 0.2)+xlim(c(0,20))+ylim(c(-100,100))

