#margin of error
#2*se
#why multiply by 2
# Pr(abs(Xbar - p) <= 2SE(Xbar)) using same equations to simplify we end up
#Pr(Z <= 2) - Pr(Z <= -2)

pnorm(2) - pnorm(-2)

#95% chance that Xbar will be within 2 standard error to p

#spread of 2 parties = p - (1-p) = 2p - 1
# to estimate use xbar = 2Xbar - 1
# standard error = 2*SE(Xbar) = 2*sqrt(p(1-p)/N)