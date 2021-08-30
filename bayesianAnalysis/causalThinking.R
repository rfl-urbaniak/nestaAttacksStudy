library(dagitty)
library(rethinking)
#A: activity
#H: hate
#I: intervention

#B, D, A: before, during, after
#T, C: type, count


large <- dagitty("
    dag{
    AB -> AD -> AA
    AB -> HB -> HD -> HA
    AD -> HD
    AA -> HA
    IT -> HD
    IT -> AD
    IT -> AA
    IT -> HA
    IC -> HD
    IC -> AD
    IC -> AA
    IC -> HA
    } 
  ")



drawdag(large)


adjustmentSets(large, exposure = c("IC", "IT"), outcome = "HA")

adjustmentSets(large, exposure = c("IC", "IT"), outcome = "HA", effect = "direct")



impliedConditionalIndependencies(large)



small <- dagitty("
    dag{
    AB ->  AA
    AB -> HB -> HA
    AA -> HA
    I -> AA
    I -> HA
    } 
  ")

drawdag(small)

adjustmentSets(small, exposure = c("I"), outcome = "HA")


adjustmentSets(small, exposure = c("I"), outcome = "HA", effect = "direct")




impliedConditionalIndependencies(large)


hidden <- dagitty("
    dag{
    UA [unobserved]
    UH [unobserved]
    AB ->  HB
    AA -> HA
    I -> AA
    I -> HA
    UA -> AB
    UA -> AA
    UH -> HB
    UH -> HA
    } 
  ")


drawdag(hidden)

adjustmentSets(hidden, exposure = c("I"), outcome = "HA", effect = "total")
adjustmentSets(hidden, exposure = c("I"), outcome = "HA", effect = "direct")



impliedConditionalIndependencies(hidden)


paths(hidden, from = "I", to = "HA", limit = 100)



