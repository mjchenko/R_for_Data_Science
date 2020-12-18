#what is probability that our estimate is within 1% of p
# Pr(abs(X_ - p) <= 0 .01)
# Pr(X_ <= p + 0.01) - Pr(X_ <= p - 0.01)

#use trick to make z-scores by subtracting expected value and dividing by se
#Pr((X_ - E(X_))/SE(X_) <= ((p + 0.01) - E(X_))/SE(X_)) - Pr((X_ - E(X_))/SE(X_) <= ((p - 0.01) - E(X_))/SE(X_))
#Pr(Z <= ((p + 0.01) - E(X_))/SE(X_) - Pr(Z <= ((p - 0.01) - E(X_))/SE(X_))
#E(X_) = p
#SE(X_) = sqrt(p(1-p)/N)

# Pr(Z <= 0.01 / sqrt(p(1-p)/N)) - Pr(Z <= -0.01/sqrt(p(1-p)/N))

#we still cannot calculate because we don't know p
#however Central limit still works if X_ is used instead of p.
#this is called a plug in estimate
# SE_estimate(X_) = sqrt(X_(1-X_)/N)

# Pr(Z <= 0.01 / sqrt(X_(1-X_)/N)) - Pr(Z <= -0.01/sqrt(X_(1-X_)/N))

#compute estimate based on first case 12 blue 13 red
Xbar = 0.48
se <- sqrt(Xbar*(1-Xbar)/25)
se

#probability that Xbar is within 1% of p
pnorm(0.01/se) - pnorm(-0.01/se)
