library(dplyr)
data(heights)

heights %>% group_by(sex) %>%
  summarize(average = mean(height), standard_deviation = sd(height))

data(murders)
murders <- murders %>% mutate(murder_rate = total/population*100000)
murders %>% group_by(region) %>%
  summarize(median_rate = median(murder_rate))