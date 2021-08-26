

user1 <- c(0,0, 0, 1, 0, 1, 0, 0, 0)
user2 <- c(0,0, 0, 0,  1, 1, 1, 0, 0)


users <- list(user1, user2)

starts <- numeric(length(users))
ends <- numeric(length(users))
for(i in 1: length(users)){
starts[i] <- min(which(users[[i]] !=0 ))-2
ends[i] <-  max(which(users[[i]] !=0 ))+2
}

starts
ends

cleanedUsers <- list()
for(i in 1: length(users)){
cleanedUsers[[i]] <- users[[i]][starts[i]:ends[i]]
}


cleanedUsers

usersDF <- do.call("rbind", cleanedUsers)


usersDF






