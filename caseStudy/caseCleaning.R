library(rethinking)
library(tidyverse)


all <- read.csv(file = "datasets/RAWNESTA/allCleanComplete.rds")
hate <- readRDS(file = "datasets/RAWNESTA/hateCleanComplete.rds")
interventions <- readRDS(file = "datasets/interventions.rds")
summaries <- read.csv(file = "datasets/Summaries.csv")

nrow(all)
nrow(hate)

summaries$ABS <- standardize(summaries$AB)
summaries$CBS <- standardize(summaries$CB)
summaries$AAS <- standardize(summaries$AA)
summaries$CAS <- standardize(summaries$CA)
summaries$CDS <- standardize(summaries$CD)
summaries$ADS <- standardize(summaries$AD)
summaries$group <- as.factor(summaries$group)
summaries$groupID <-  as.integer( as.factor(summaries$group) )


head(interventions)


ABS <- c("low", "medium", "high")
CBS <- c("low", "medium", "high")

groups <- expand.grid(ABS = ABS, CBS = CBS)

groups

head(summaries)

min(summaries$ABS)
max(summaries$ABS)
min(summaries$CBS)
max(summaries$CBS)



ggplot(summaries, aes(x = ABS)) +geom_histogram()
ggplot(summaries, aes(x = CBS)) +geom_histogram()




ll <- summaries %>% filter(ABS < -.495 & CBS < -.495 & IC > 1)  # bottom 10

ll

user <- as.character(ll$author[10])

user

output <- all[all$author == user,]

nrow(output)

output$text  

user

attacks <- hate %>% filter(author == user) %>% select(day,id,text)


attacks

colnames(summaries)

summaries[summaries$author == user,]
