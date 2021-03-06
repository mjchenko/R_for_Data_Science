n <- 1000
loss_per_foreclosure <- -200000
p <- 0.02
defaults <- sample( c(0,1), n, prob=c(1-p, p), replace = TRUE)
sum(defaults * loss_per_foreclosure)

B <- 10000
losses <- replicate(B, {
  defaults <- sample( c(0,1), n, prob=c(1-p, p), replace = TRUE) 
  sum(defaults * loss_per_foreclosure)
})


library(tidyverse)
data.frame(losses_in_millions = losses/10^6) %>%
  ggplot(aes(losses_in_millions)) +
  geom_histogram(binwidth = 0.6, col = "black")

# 2 values so expect normal distribution and can apply theorem
n*(p*loss_per_foreclosure + (1-p)*0)    # expected value 
sqrt(n)*abs(loss_per_foreclosure)*sqrt(p*(1-p))    # standard error

# We can calculate the amount  𝑥  to add to each loan so that the expected value 
# is 0 using the equation  𝑙𝑝+𝑥(1−𝑝)=0 . Note that this equation is the 
# definition of expected value given a loss per foreclosure  𝑙  with 
# foreclosure probability  𝑝  and profit  𝑥  if there is no foreclosure 
# (probability  1−𝑝 ).
x = - loss_per_foreclosure*p/(1-p)
x / 180000

# We want to calculate the value of  𝑥  for which  Pr(𝑆<0)=0.01 . 
# The expected value  E[𝑆]  of the sum of  𝑛=1000 loans given our 
# definitions of  𝑥 ,  𝑙  and  𝑝  is:
# e_val = n(lp + x(1-p))
#se = sqrt(n) * abs(x-l)*sqrt(p*(1-p))

# Because we know the definition of a Z-score is  𝑍=𝑥−𝜇𝜎 , we know that  
# Pr(𝑆<0)=Pr(𝑍<−𝜇𝜎) . Thus,  Pr(𝑆<0)=0.01  equals:
# Pr(𝑍<−{𝑙𝑝+𝑥(1−𝑝)}𝑛/[(𝑥−𝑙)sqrt(𝑛𝑝(1−𝑝))]=0.01 
# z<-qnorm(0.01) gives us the value of  𝑧  for which  Pr(𝑍≤𝑧)=0.01 
# solving for x


l <- loss_per_foreclosure
z <- qnorm(0.01)
x <- -l*( n*p - z*sqrt(n*p*(1-p)))/ ( n*(1-p) + z*sqrt(n*p*(1-p)))
x/180000    # interest rate
loss_per_foreclosure*p + x*(1-p)    # expected value of the profit per loan
n*(loss_per_foreclosure*p + x*(1-p)) # expected value of the profit over n loans

B <- 100000
profit <- replicate(B, {
  draws <- sample( c(x, loss_per_foreclosure), n, 
                   prob=c(1-p, p), replace = TRUE) 
  sum(draws)
})
mean(profit)    # expected value of the profit over n loans
mean(profit<0)    # probability of losing money



# he Central Limit Theorem states that the sum of independent draws of a random 
# variable follows a normal distribution. However, when the draws are not 
# independent, this assumption does not hold

# If an event changes the probability of default for all borrowers, then the 
# probability of the bank losing money changes
p <- .04
loss_per_foreclosure <- -200000
r <- 0.05
x <- r*180000
loss_per_foreclosure*p + x*(1-p)

z <- qnorm(0.01)
l <- loss_per_foreclosure
n <- ceiling((z^2*(x-l)^2*p*(1-p))/(l*p + x*(1-p))^2)
n    # number of loans required
n*(loss_per_foreclosure*p + x * (1-p))    # expected profit over n loans

B <- 10000
p <- 0.04
x <- 0.05 * 180000
profit <- replicate(B, {
  draws <- sample( c(x, loss_per_foreclosure), n, 
                   prob=c(1-p, p), replace = TRUE) 
  sum(draws)
})
mean(profit)
mean(profit<0)

# This Monte Carlo simulation estimates the expected profit given an unknown 
# probability of default  0.03≤𝑝≤0.05 , modeling the situation where an event 
# changes the probability of default for all borrowers simultaneously. 

p <- 0.04
x <- 0.05*180000
profit <- replicate(B, {
  new_p <- 0.04 + sample(seq(-0.01, 0.01, length = 100), 1)
  draws <- sample( c(x, loss_per_foreclosure), n, 
                   prob=c(1-new_p, new_p), replace = TRUE)
  sum(draws)
})
mean(profit)    # expected profit
mean(profit < 0)    # probability of losing money
mean(profit < -10000000)    # probability of losing over $10 million