library(rethinking)
library(tidyverse)
library(ggthemes)
library(stats)
library(forecast)

getwd()
summaries <- read.csv(file = "datasets/Summaries.csv")

head(summaries)



hate <- readRDS(file = "datasets/RAWNESTA/Hate.rds")
comments <- readRDS(file = "datasets/RAWNESTA/Comments.rds")
interventions <- readRDS(file = "datasets/interventions.rds")

interventionsByAuthorDate <- as.data.frame(xtabs(~ author + day, data = interventions))

str(interventionsByAuthorDate)
hate$author  <- as.character(hate$author)
comments$author  <- as.character(comments$author)
interventionsByAuthorDate$author  <- as.character(interventionsByAuthorDate$author)



mean(hate$author %in% comments$author)
mean(comments$author %in% hate$author)
mean(interventionsByAuthorDate$author %in% hate$author)


