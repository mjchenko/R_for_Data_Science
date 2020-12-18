# summarizing with dplyr
library(dplyr)
library(dslabs)
data(heights)

s <- heights %>%
  filter(sex == "Male") %>%
  summarize(average = mean(height), standard_deviation = sd(height))
#stored in s as a dataframe so we can access with $
s
s$average
s$standard_deviation

# can also do the min, max, median 
heights %>% filter(sex == "Male") %>%
  summarize(median = median(height),
  minimum = min(height), 
  maximum = max(height))

# summarize can only call functions that return a single value
# so it could not do something like this 
# heights %>%
#   filter(sex == "Male") %>%
#   summarize(range = quantile(height, c(0, 0.5, 1)))