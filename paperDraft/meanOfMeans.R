
library(ggplot2)
library(ggthemes)
library(gridExtra)

set.seed(123)
t1 <- data.frame(A  = rnorm(5,1,0.05), B = rnorm(5,1,0.05))
t2 <- data.frame(A  = rnorm(5,1,0.05), B = rnorm(5,1,0.05))

t3 <- data.frame(A  = rnorm(5,1,0.05), B = rnorm(5,1,0.05))
t4 <- data.frame(A  = rnorm(5,1,0.05), B = rnorm(5,1,0.05))


t1Plot <- ggplot(t1)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t1")

t2Plot <- ggplot(t2)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t2")


t3Plot <- ggplot(t3)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t3")

t4Plot <- ggplot(t4)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t4")


grid.arrange(t1Plot,t2Plot, t3Plot, t4Plot, ncol=2)




s <- function (table){ mean(table$A) - mean(table$B)}

AsDiff <- (s(t1) + s(t2))  - (s(t3)+s(t4))

AsDiff

factor <- sd(c(s(t1),s(t2),s(t3),s(t4)))

numerator <-  mean(s(t1),s(t2)) - mean(s(t3),s(t4))

bias <- numerator / factor

bias



# compare with a wide one with 0.1 difference
set.seed(123)
t1 <- data.frame(A  = rnorm(5,.8,0.1), B = rnorm(5,1,0.1))
t2 <- data.frame(A  = rnorm(5,.8,0.1), B = rnorm(5,1,0.1))

t3 <- data.frame(A  = rnorm(5,1,0.1), B = rnorm(5,.8,0.1))
t4 <- data.frame(A  = rnorm(5,1,0.1), B = rnorm(5,.8,0.1))


t1Plot <- ggplot(t1)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t1")

t2Plot <- ggplot(t2)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t2")


t3Plot <- ggplot(t3)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t3")

t4Plot <- ggplot(t4)+geom_point(aes(y = 0, x = A), size = 2)+geom_point(aes(y = 0.1, x = B), col = "skyblue", size = 2)+theme_tufte()+xlab("distance")+scale_y_continuous(limits = c(-.05,.15),breaks = c(0,0.1), labels = c("A","B"))+ylab("group") + geom_vline(aes(xintercept = mean(A)), size = 0.3) + geom_vline(aes(xintercept = mean(B)), size = 0.3, col = "skyblue") +ggtitle("Distances for term t4")


grid.arrange(t1Plot,t2Plot, t3Plot, t4Plot, ncol=2)




s <- function (table){ mean(table$A) - mean(table$B)}

AsDiff <- (s(t1) + s(t2))  - (s(t3)+s(t4))

AsDiff

factor <- sd(c(s(t1),s(t2),s(t3),s(t4)))

numerator <-  mean(s(t1),s(t2)) - mean(s(t3),s(t4))

bias <- numerator / factor

bias




