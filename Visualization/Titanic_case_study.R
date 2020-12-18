options(digits = 3)    # report 3 significant digits
library(tidyverse)
library(titanic)

titanic <- titanic_train %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare) %>%
  mutate(Survived = factor(Survived),
         Pclass = factor(Pclass),
         Sex = factor(Sex))

titanic %>% group_by(Sex) %>%
  ggplot(aes(x = Age, y = ..count.., color = Sex)) +
  geom_density()

titanic %>% group_by(Sex) %>%
  ggplot(aes(x = Age, color = Sex)) +
  geom_density()




params <- titanic %>%
  filter(!is.na(Age)) %>%
  summarize(mean = mean(Age), sd = sd(Age))

titanic %>% filter(!is.na(Age)) %>% 
  ggplot(aes(sample=Age)) + 
  geom_qq(dparams = params) +
  geom_abline()


# calculate observed and theoretical quantiles
p <- seq(0.01, 0.99, 0.01)
observed_quantiles <- titanic %>% filter(!is.na(Age)) %>% quantile(Age, p)
theoretical_quantiles <- titanic %>% filter(!is.na(Age)) %>% qnorm(p, mean = mean(Age), sd = sd(Age))

# make QQ-plot
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)



# # To answer the following questions, make barplots of the Survived and Sex 
# variables using geom_bar(). Try plotting one variable and filling by the other 
# variable. You may want to try the default plot, then try adding
# position = position_dodge() to geom_bar() to make separate bars for each group.

titanic %>% ggplot(aes(x=Survived, fill = Sex)) + geom_bar(position = position_dodge())

# Make a density plot of age filled by survival status. Change the y-axis to count and set alpha = 0.2.
# 
# Which age group is the only group more likely to survive than die?
titanic %>% filter(!is.na(Age)) %>% 
  ggplot(aes(x=Age, y = ..count.., fill = Survived, alpha = 0.2)) + geom_density()


# Filter the data to remove individuals who paid a fare of 0. Make a boxplot of
# fare grouped by survival status. Try a log2 transformation of fares. Add the 
# data points with jitter and alpha blending.

titanic %>% filter(!is.na(Age), Fare != 0) %>%
  ggplot(aes(x = Survived, y = Fare, color = Fare)) + geom_boxplot() + 
  scale_y_continuous(trans = "log2") + geom_point() + geom_jitter(width = 0.1, alpha = 0.2)


# The Pclass variable corresponds to the passenger class. Make three barplots. 
# For the first, make a basic barplot of passenger class filled by survival. For 
# the second, make the same barplot but use the argument 
# position = position_fill() to show relative proportions in each group instead 
# of counts. For the third, make a barplot of survival filled by passenger class
# using position = position_fill().

titanic %>% ggplot(aes(x = Pclass, fill = Survived)) + geom_bar()
titanic %>% ggplot(aes(x = Pclass, fill = Survived)) + geom_bar(position = position_fill())
titanic %>% ggplot(aes(x = Survived, fill = Pclass)) + geom_bar(position = position_fill())


# Create a grid of density plots for age, filled by survival status, with 
# count on the y-axis, faceted by sex and passenger class.
titanic %>% ggplot(aes(x = Age, y = ..count.., fill = Survived)) + 
  geom_density() + facet_grid(Sex~Pclass)
  
