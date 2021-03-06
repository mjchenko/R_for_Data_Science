# Simulated data with  𝑋𝑗=𝑑+𝜖𝑗 
J <- 6
N <- 2000
d <- .021
p <- (d+1)/2
X <- d + rnorm(J, 0, 2*sqrt(p*(1-p)/N))



# Simulated data with  𝑋𝑖,𝑗=𝑑+𝜖𝑖,𝑗 
I <- 5
J <- 6
N <- 2000
d <- .021
p <- (d+1)/2
X <- sapply(1:I, function(i){
  d + rnorm(J, 0, 2*sqrt(p*(1-p)/N))
})




# Simulated data with  𝑋𝑖,𝑗=𝑑+ℎ𝑖+𝜖𝑖,𝑗 
I <- 5
J <- 6
N <- 2000
d <- .021
p <- (d+1)/2
h <- rnorm(I, 0, 0.025)    # assume standard error of pollster-to-pollster variability is 0.025
X <- sapply(1:I, function(i){
  d + rnorm(J, 0, 2*sqrt(p*(1-p)/N))
})




# Calculating probability of  𝑑>0  with general bias
# 
# Note that sigma now includes an estimate of the variability due to general bias  𝜎𝑏=.025 .
mu <- 0
tau <- 0.035
sigma <- sqrt(results$se^2 + .025^2)
Y <- results$avg
B <- sigma^2 / (sigma^2 + tau^2)

posterior_mean <- B*mu + (1-B)*Y
posterior_se <- sqrt(1 / (1/sigma^2 + 1/tau^2))

1 - pnorm(0, posterior_mean, posterior_se)