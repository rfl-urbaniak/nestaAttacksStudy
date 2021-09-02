library(dagitty)
library(rethinking)
#A: activity
#H: hate
#I: intervention

#B, D, A: before, during, after
#T, C: type, count

dag <- dagitty("
    dag{
        AD -> HD -> IC
        U [unobserved]
        U -> AD
        U -> HD
        U -> AC
        U -> HC
        AC -> HC
        IC -> AC
        IC -> HC
        IT -> AC
        IT -> HC
        }")


drawdag(dag)


paths(dag, from = c("IC"), to = "HC")



paths(dag, from = c("IC"), to = "AC")



impliedConditionalIndependencies(dag)

adjustmentSets(dag, exposure = c("IC", "IT"), outcome = "HC")

adjustmentSets(dag, exposure = c("IC", "IT"), outcome = "AC")




adjustmentSets(dag, exposure = c("IC", "IT"), outcome = "AC", effect = "direct")
adjustmentSets(dag, exposure = c("IC"), outcome = "AC", effect = "direct")



adjustmentSets(dag, exposure = c("IC", "IT"), outcome = "HC", effect = "direct")






length(equivalentDAGs(dag))

# Plot all equivalent DAGs
par( mfrow=c(4,4) )
lapply( equivalentDAGs(dag), plot )

# How many edges can be reversed 

edges(equivalenceClass(dag2))[edges(equivalenceClass(dag))$e == "--",]





dag2 <- dagitty("
               dag{
               AD -> HD -> IC
               AD -> AC
               HD  -> HC
               U [unobserved]
               U -> AD
               U -> HD
               U -> AC
               U -> HC
               AC -> HC
               IC -> AC
               IC -> HC
               IT -> AC
               IT -> HC
               }")


drawdag(dag2)


paths(dag2, from = c("IC"), to = "HC")



paths(dag2, from = c("IC"), to = "AC")



impliedConditionalIndependencies(dag2)

adjustmentSets(dag2, exposure = c("IC", "IT"), outcome = "HC")

adjustmentSets(dag2, exposure = c("IC", "IT"), outcome = "AC")




adjustmentSets(dag2, exposure = c("IC", "IT"), outcome = "AC", effect = "direct")
adjustmentSets(dag2, exposure = c("IC"), outcome = "AC", effect = "direct")

adjustmentSets(dag2, exposure = c("IC", "IT"), outcome = "HC", effect = "direct")




length(equivalentDAGs(dag2))

# Plot all equivalent DAGs
par( mfrow=c(2,4) )
lapply( equivalentDAGs(dag2), plot )

# How many edges can be reversed without c

edges(equivalenceClass(dag2))[edges(equivalenceClass(dag2))$e == "--",]

