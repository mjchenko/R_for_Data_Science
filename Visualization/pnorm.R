library(tidyverse)
library(dslabs)
library(dbplyr)
data(heights)
x <- heights %>% filter(sex=="Male") %>% pull(height)

# estimate that a male is taller than 70.5 in
1 - pnorm(70.5, mean(x), sd(x))

# plot distribution of exact heights in data
plot(prop.table(table(x)), xlab = "a = Height in inches", ylab = "Pr(x = a)")

# probabilities in actual data over length 1 ranges containing an integer
mean(x <= 68.5) - mean(x <= 67.5)
mean(x <= 69.5) - mean(x <= 68.5)
mean(x <= 70.5) - mean(x <= 69.5)

# probabilities in normal approximation match well
pnorm(68.5, mean(x), sd(x)) - pnorm(67.5, mean(x), sd(x))
pnorm(69.5, mean(x), sd(x)) - pnorm(68.5, mean(x), sd(x))
pnorm(70.5, mean(x), sd(x)) - pnorm(69.5, mean(x), sd(x))

# probabilities in actual data over other ranges don't match normal approx as well
mean(x <= 70.9) - mean(x <= 70.1)
pnorm(70.9, mean(x), sd(x)) - pnorm(70.1, mean(x), sd(x))


# Definition of qnorm
# 
# The qnorm() function gives the theoretical value of a quantile with probability p of observing a value equal to or less than that quantile value given a normal distribution with mean mu and standard deviation sigma:
#   
# qnorm(p, mu, sigma)
# By default, mu=0 and sigma=1. Therefore, calling qnorm() with no arguments gives quantiles for the standard normal distribution.

# qnorm(p)
# Recall that quantiles are defined such that p is the probability of a random observation less than or equal to the quantile.
# 
# Relation to pnorm
# 
# The pnorm() function gives the probability that a value from a standard normal distribution will be less than or equal to a z-score value z. Consider:
#   
  # pnorm(-1.96)  ≈0.025 

# The result of pnorm() is the quantile. Note that:
#   
#   qnorm(0.025)  ≈−1.96 
# 
# qnorm() and pnorm() are inverse functions:
#   
#   pnorm(qnorm(0.025))  =0.025 
# 
# Theoretical quantiles
# 
# You can use qnorm() to determine the theoretical quantiles of a dataset: that is, the theoretical value of quantiles assuming that a dataset follows a normal distribution. Run the qnorm() function with the desired probabilities p, mean mu and standard deviation sigma. 
# 
# Suppose male heights follow a normal distribution with a mean of 69 inches and standard deviation of 3 inches. The theoretical quantiles are:
#   
#   p <- seq(0.01, 0.99, 0.01)
# theoretical_quantiles <- qnorm(p, 69, 3)
# Theoretical quantiles can be compared to sample quantiles determined with the quantile function in order to evaluate whether the sample follows a normal distribution.