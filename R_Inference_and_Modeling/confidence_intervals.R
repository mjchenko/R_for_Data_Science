#Confidence intervals
#confidence interval within 95% or 2SE away
#Pr(Xbar - 2SEhat(Xbar) <= p <= X + 2SEhat(Xbar))
#Pr(-2 <= (p - Xbar)/2SEhat(Xbar) <= 2)
#Pr(-2 <= Z <= 2)
pnorm(-2) + pnorm(2)

# if we want a different percentage we do
#Pr(-z <= Z <= z) = 0.99
z <- qnorm(0.995)
#by definition pnorm(qnorm(0.995)) = 0.995
pnorm(qnorm(0.995))
# by symetry pnorm(qnorm(1 - 0.995)) = .005
#so subrtacting should give us the correct probability for the interval
pnorm(z) - pnorm(-z)

#we can do this for any interval q we want. solve
#z = 1 - (1-q)/2







library(tidyverse)
library(dplyr)
# we can run a monte carlo to confirm that a 95% confidence interval contains p 95% of the time
N = 100
p = 0.48
B <- 10000
inside <- replicate(B, {
  X <- sample(c(0,1), size = N, replace = TRUE, prob = c(1-p, p))
  X_hat <- mean(X)
  SE_hat <- sqrt(X_hat*(1-X_hat)/N)
  between(p, X_hat - 2*SE_hat, X_hat + 2*SE_hat)    # TRUE if p in confidence interval
})
mean(inside)



#Note that to compute the exact 95% confidence interval, we would use 
#qnorm(.975)*SE_hat instead of 2*SE_hat.
N = 100
p = 0.48
B <- 10000
inside <- replicate(B, {
  X <- sample(c(0,1), size = N, replace = TRUE, prob = c(1-p, p))
  X_hat <- mean(X)
  SE_hat <- sqrt(X_hat*(1-X_hat)/N)
  between(p, X_hat - qnorm(0.975)*SE_hat, X_hat + qnorm(0.975)*SE_hat)    # TRUE if p in confidence interval
})
mean(inside)



#confidence interval of spread with sample size of 25
# note we would use c(-qnorm(.975), qnorm(.975)) to get exactly 95% 
N <- 25
X_hat <- 0.48
(2*X_hat - 1) + c(-2, 2)*2*sqrt(X_hat*(1-X_hat)/N)