#bayesian statistics
# Bayes' Theorem states that the probability of event A happening given event B 
# is equal to the probability of both A and B divided by the probability of 
# event B

# Pr(A | B) = Pr(B|A)*Pr(A)/Pr(B)

# example

# In these probabilities, + represents a positive test, - represents a 
# negative test,  𝐷=0  indicates no disease, and  
# 𝐷=1 indicates the disease is present.

#probability of having disease given a positive test 
# Pr(D = 1 | + )

# test 99% accuracy when disease is present or absent
# Pr(+ | D = 1) = 0.99
# Pr(- | D = 0) = 0.99

# rate of cystic fibrosis
# Pr(𝐷=1)=0.00025 

# Bayes Theorem
# Pr(D = 1 | +) = Pr(+ | D = 1) * Pr(D = 1)/Pr(+)
# Pr(D = 1 | +) = Pr(+ | D = 1) * Pr(D = 1)/(Pr(+ | D = 1)*Pr(D = 1) + Pr(+ | D = 0)*Pr(D = 0))
# = 0.99*0.00025/(0.99*0.00025 + 0.01*0.99975) = 0.02


####using a monte carlo to show this result
prev <- 0.00025    # disease prevalence
N <- 100000    # number of tests
outcome <- sample(c("Disease", "Healthy"), N, replace = TRUE, prob = c(prev, 1-prev))

N_D <- sum(outcome == "Disease")    # number with disease
N_H <- sum(outcome == "Healthy")    # number healthy

# for each person, randomly determine if test is + or -
accuracy <- 0.99
test <- vector("character", N)
test[outcome == "Disease"] <- sample(c("+", "-"), N_D, replace=TRUE, prob = c(accuracy, 1-accuracy))
test[outcome == "Healthy"] <- sample(c("-", "+"), N_H, replace=TRUE, prob = c(accuracy, 1-accuracy))

table(outcome, test)


