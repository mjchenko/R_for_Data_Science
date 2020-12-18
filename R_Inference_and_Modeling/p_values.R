#p_values

#suppose i want to know if there are more blue beads than red beads
#i.e is 2p - 1 > 0
# suppose we draw 100 beads and 52 are blue
# spread = 2p - 1 = 2*.52 - 1 = 0.04
#we need to be skeptical because the spread could be 0 and we could have 
#randomly got 52 in that one draw
# NULL hypothesis -> spread is 0

#p value <- how likely is it to see a value this large if null hypothesis is true

#Pr(abs(Xbar - 0.5) > 0.02)

#under null hypothesis
# sqrt(N)*(Xbar - 0.5)/sqrt(0.5*(1-0.5)) is a standard normal

#Pr(sqrt(N)*(Xbar - 0.5)/sqrt(0.5*(1-0.5)) > sqrt(N)*0.02/sqrt(0.5*(1-0.5)))
#Pr(sqrt(N)*(Xbar - 0.5)/sqrt(0.5*(1-0.5)) > Z)

# p value for spread if null hypothesis is true
N = 100
z <- sqrt(N)*0.02/0.5
1 - (pnorm(z) - pnorm(-z))
#large chance of seeing 52 beads if the actual porportion is equal

#if a 95% confidence interval of the spread does not include 0, we know that the
# p value must be smaller than 0.05
#generally we prefer to use confidence intervals over p values