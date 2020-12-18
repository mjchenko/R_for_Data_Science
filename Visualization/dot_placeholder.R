library(dplyr)
library(dslabs)
data(murders)
murders <- murders %>% mutate(murder_rate = total/population*100000)
# this is not the US murder rate, this is the average of the murder rates of
# each state.
summarize(murders, mean(murder_rate))

# correct us murder rate is total murders / total pop
us_murder_rate <- murders %>% 
  summarize(rate = sum(total) / sum(population) * 100000)

#summarize almost always returns dataframes
us_murder_rate
class(us_murder_rate)

#use the dot to access and get a numeric
us_murder_rate <- us_murder_rate %>% .$rate
class(us_murder_rate)

#in one line of code to numeric
us_murder_rate <- murders %>% 
  summarize(rate = sum(total) / sum(population) * 100000) %>%
  .$rate
us_murder_rate
class(us_murder_rate)
