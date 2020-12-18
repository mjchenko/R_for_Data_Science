library(HistData)
data("GaltonFamilies")
galton_heights <- GaltonFamilies %>% 
  filter(childNum == 1 & gender == "male") %>% 
  select(father, childHeight) %>%
  rename(son = childHeight)


# compute a regression line to predict the son's height (y) from the father's height (x)
# E(Y | X = x)
mu_x <- mean(galton_heights$father)
mu_y <- mean(galton_heights$son)
s_x <- sd(galton_heights$father)
s_y <- sd(galton_heights$son)
r <- cor(galton_heights$father, galton_heights$son)
m_1 <-  r * s_y / s_x
b_1 <- mu_y - m_1*mu_x

# compute a regression line to predict the father's height (x) from the son's height (y)
# E(X | Y = y)
m_2 <-  r * s_x / s_y
b_2 <- mu_x - m_2*mu_y


#what percent of variation in sons height is explained by fathers height
#rho^2
(0.5^2)
#variation expected
# Var(Y | X = y) = sigma_y^2 * (1-rho^2)
s_y^2* (1-0.5^2)


# Suppose the correlation between father and son’s height is 0.5, the standard 
# deviation of fathers’ heights is 2 inches, and the
# standard deviation of sons’ heights is 3 inches.
r = 0.5
s_y = 3
s_x = 2

# Given a one inch increase in a father’s height, what is the predicted change 
# in the son’s height?
# E(Y | X = x)
m = r * s_y / s_x
y_0 = m*(35)
y_1 = m*(36) 
y_1 - y_0
