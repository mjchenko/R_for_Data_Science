library(tidyverse)
library(dslabs)

# To do this, we generate results for 12 polls taken the week before the election.
# We mimic sample sizes from actual polls and construct and report 95% 
# confidence intervals for each of the 12 polls. We save the results from 
# this simulation in a data frame and add a poll ID column.


d <- 0.039
Ns <- c(1298, 533, 1342, 897, 774, 254, 812, 324, 1291, 1056, 2172, 516)
p <- (d + 1) / 2

polls <- map_df(Ns, function(N) {
  x <- sample(c(0,1), size=N, replace=TRUE, prob=c(1-p, p))
  x_hat <- mean(x)
  se_hat <- sqrt(x_hat * (1 - x_hat) / N)
  list(estimate = 2 * x_hat - 1, 
       low = 2*(x_hat - 1.96*se_hat) - 1, 
       high = 2*(x_hat + 1.96*se_hat) - 1,
       sample_size = N)
}) %>% mutate(poll = seq_along(Ns))



# Although as aggregators we do not have access to the raw poll data, 
# we can use mathematics to reconstruct what we would have obtained 
# had we made one large poll with:
sum(polls$sample_size)

d_hat <- polls %>% 
  summarize(avg = sum(estimate*sample_size) / sum(sample_size)) %>% 
  pull(avg)

# Once we have an estimate of  
# d, we can construct an estimate for the proportion voting for Obama, 
# which we can then use to estimate the standard error. Once we do this, 
# we see that our margin of error is 0.018.
x_hat <- (d_hat + 1)/2
m_of_e <- 2*1.96*sqrt(x_hat * (1-x_hat) / sum(polls$sample_size))


