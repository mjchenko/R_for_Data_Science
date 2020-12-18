# if you have 50 people in your class. what is the chance that two people have 
# the same birthday
n <- 50
bdays <- sample(1:365, n, replace = TRUE)

#use duplicated to check if something has already shown up in the vector
#example. returns true for 1 and 3 the second time they appear
duplicated(c(1, 2, 3, 1, 4, 3, 5))

any(duplicated(bdays))

#monte carlo to find this probability
results <- replicate(B, {
  bdays <- sample(1:365, n, replace = TRUE)
  any(duplicated(bdays))
})
mean(results)




# create a function for monte carlo simulations with changing group size (n)
compute_prob <- function(n, B = 10000){
  same_day <- replicate(B, {
    bdays <- sample(1:365, n, replace = TRUE)
    any(duplicated(bdays))
  })
  mean(same_day)
}

n = seq(1,60)

# could use a for loop for each n, however in R we try to perform operations on
# complete vectors
# use s apply -> element wise operations on any function
# for example
x <- 1:10
sapply(x, sqrt)

#get the probabilities for different group sizes
prob <- sapply(n, compute_prob)



# we can compute this mathematically
# it is easier to take these probabilities by computing the cases where it is not true
#Pr(person 1 has a unique birthday) = 1
#Pr(person 2 has a unique birthday | person 1 has a unique birthday) = 364 / 365
#Pr(person 3 has a unique birthday | person 1 and person 2 have unique birthdays) = 363 / 365
# 1 x 364/365 x 363/365 x (365 - n + 1)/365
exact_prob <- function(n){
  prob_unique <- seq(365, 365 - n + 1)/365
  1-prod(prob_unique)
}
e_prob <- sapply(n, exact_prob)

plot(n, prob)
lines(n, e_prob, color = "red")