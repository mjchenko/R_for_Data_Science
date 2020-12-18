# Capital letters denote random variables ( 𝑋 ) and lowercase letters denote 
# observed values ( 𝑥 ).
# In the notation  Pr(𝑋=𝑥) , we are asking how frequently the random variable  
# 𝑋  is equal to the value  𝑥 . For example, if  𝑥=6 , this statement becomes  
# Pr(𝑋=6) .

# These equations apply to the case where there are only two outcomes, 𝑎 and 𝑏 
# with proportions 𝑝 and 1−𝑝 respectively. The general principles above also 
# apply to random variables with more than two outcomes.
# 
# Expected value of a random variable: 
#   𝑎𝑝+𝑏(1−𝑝)
# 
# Expected value of the sum of n draws of a random variable: 
#   𝑛×(𝑎𝑝+𝑏(1−𝑝))
# 
# Standard deviation of an urn with two values: 
#   ∣𝑏–𝑎∣sqrt(𝑝(1−𝑝))
# 
# Standard error of the sum of n draws of a random variable:
#    sqrt(n)*∣𝑏–𝑎∣sqrt(𝑝(1−𝑝))

# Random variable times a constant
# The expected value of a random variable multiplied by a constant is that constant times its original expected value:
#   
#   E[𝑎𝑋]=𝑎𝜇 
# 
# The standard error of a random variable multiplied by a constant is that constant times its original standard error:
#   
#   SE[𝑎𝑋]=𝑎𝜎 
# 
# Average of multiple draws of a random variable
# The expected value of the average of multiple draws from an urn is the 
# expected value of the urn ( 𝜇 ).
# 
# The standard deviation of the average of multiple draws from an urn is the 
# standard deviation of the urn divided by the square root of the number of draws ( 𝜎/𝑛√ ).
# 
# The sum of multiple draws of a random variable
# The expected value of the sum of  𝑛  draws of a random variable is  𝑛  
# times its original expected value:
#   
#   E[𝑛𝑋]=𝑛𝜇 
# 
# The standard error of the sum of  𝑛  draws of random variable is  √n  times 
# its original standard error:
#   
#   SE[𝑛𝑋]=𝑛√𝜎 
# 
# The sum of multiple different random variables
# The expected value of the sum of different random variables is the sum of the 
# individual expected values for each random variable:
#   
#   E[𝑋1+𝑋2+⋯+𝑋𝑛]=𝜇1+𝜇2+⋯+𝜇𝑛 
# 
# The standard error of the sum of different random variables is the square 
# root of the sum of squares of the individual standard errors:
#   
#   SE[𝑋1+𝑋2+⋯+𝑋𝑛]=√𝜎1^2 + 𝜎2^2....
# 
# Transformation of random variables
# If  𝑋  is a normally distributed random variable and  𝑎  and  𝑏  are non-random constants, then  𝑎𝑋+𝑏  is also a normally distributed random variable.