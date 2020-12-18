# We model baseball player hitting using a hierarchical model with two levels of
# variability
# 𝑝∼𝑁(𝜇,𝜏)  describes player-to-player variability in natural ability to hit, 
# which has a mean  𝜇  and standard deviation  𝜏 .

# 𝑌∣𝑝∼𝑁(𝑝,𝜎)  describes a player's observed batting average given their ability  𝑝,
# which has a mean  𝑝  and standard deviation  𝜎=sqrt(p(1−𝑝)/𝑁) . This represents variability due to luck.



# The posterior distribution allows us to compute the probability
# distribution of  𝑝  given that we have observed data  𝑌 .
# By the continuous version of Bayes' rule, the expected value of the
# posterior distribution  𝑝  given  𝑌=𝑦  is a weighted average between the
# prior mean  𝜇  and the observed data  𝑌 :
# E(𝑝∣𝑦)=𝐵𝜇+(1−𝐵)𝑌      where𝐵=𝜎^2/(𝜎^2+𝜏2)

# The standard error of the posterior distribution 
# SE(𝑝∣𝑌)2  is 1/(1/𝜎^2+1/𝜏^2) 
# Note that you will need to take the square root of both sides to solve for the standard error.

# This Bayesian approach is also known as shrinking. 
# When  𝜎  is large,  𝐵  is close to 1 and our prediction of  𝑝  shrinks 
# towards the mean (\mu). 
# When  𝜎  is small,  𝐵  is close to 0 and our prediction of  𝑝  
# is more weighted towards the observed data  𝑌 .

