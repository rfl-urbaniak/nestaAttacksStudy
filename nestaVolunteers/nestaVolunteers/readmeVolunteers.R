#DATASETS



#PROCESS
#cleaning and preparing data is here 
file.edit("engagementSetup.R")
#now the working dataset is ""datasets/volunteersJoint.rds" 
#and in the list form for model processing as"datasets/volunteerDat.rds"


# building visualisations in vVisualisations.R
file.edit("vVisualisations.R")




#then we're building a null model

file.edit("vNull.R")

#then we compare to models with predictors
file.edit("vPred.R")

