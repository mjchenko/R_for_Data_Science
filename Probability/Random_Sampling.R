library(tidyverse)
library(dplyr)

#Roulette Game
color <- rep(c("Black", "Red", "Green"), c(18,18,2))

# 1000 draws
n <- 1000
#redo experiment 10000 times
B <- 10000

# sampling 1000 times
X <- sample(ifelse(color == "Red", -1, 1), n, replace = TRUE)
X[1:10]

#because we know the probabilities we can do it in one line
X <- sample(c(-1,1), n, replace = TRUE, prob=c(9/19, 10/19))

#10000 time monte carlo
S <- replicate(B, {
  X <- sample(c(-1,1), n, replace = TRUE, prob=c(9/19, 10/19))
  sum(X)
})

#how often does the house lose money
#mean(S <= a)
mean(S <= 0)

data.frame(S = S) %>% ggplot(aes(x=S, y = ..density..)) + geom_histogram()

#distribution looks normal so we can do some other things
avg = mean(S)
stdev = sd(S)

s <- seq(min(S), max(S), length = 100)
normal_density <- data.frame(s = s, f=dnorm(s, avg, stdev))

data.frame(S = S) %>% ggplot(aes(x = S, y = ..density..)) + 
  geom_histogram(color = "black", binwidth = 10) + 
  geom_line(data = normal_density, mapping = aes(s,f), color = "blue") +
  ylab("probability")

#expected value and standard error of random variable 
  