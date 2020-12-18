library(tidyverse)
library(dslabs)
data(heights)
x <- heights %>% filter(sex == "Male") %>% .$height
F <- function(a) mean(x <= a)
1 - F(70)    # probability of male taller than 70 inches

#random quantity is normally distributed if its distribution is defined by
#F(a) = pnorm(a, avg, s)
#useful because we dont need the whole dataset if we can use this approximation
1 = pnorm(70.5, mean(x), sd(x))




# We can use dnorm() to plot the density curve for the normal distribution. 
# dnorm(z) gives the probability density  𝑓(𝑧) of a certain z-score, so we 
# can draw a curve by calculating the density over a range of possible values of z.
# 
# First, we generate a series of z-scores covering the typical range of the 
# normal distribution. Since we know 99.7% of observations will be within  −3≤𝑧≤3 ,
# we can use a value of  𝑧  slightly larger than 3 and this will cover most likely
# values of the normal distribution. Then, we calculate  𝑓(𝑧) , which is dnorm() 
# of the series of z-scores. Last, we plot  𝑧 against  𝑓(𝑧) .
library(tidyverse)
x <- seq(-4, 4, length = 100)
data.frame(x, f = dnorm(x)) %>%
  ggplot(aes(x, f)) +
  geom_line()


# Note that dnorm() gives densities for the standard normal distribution by 
# default. Probabilities for alternative normal distributions with mean mu and 
# standard deviation sigma can be evaluated with:
dnorm(z, mu, sigma)