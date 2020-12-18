library(dslabs)
library(ggplot2)
data(gapminder)

# person living off of less than $2 per day is considered absolute poverty
# calculate how much each person is living off and add it to the data set
gapminder <- gapminder %>% mutate(dollars_per_day = gdp/population/365)

# values in the table for gdp are adjusted for inflation so should be comparable
# across years
# these are country averages. could be variations within countries
past_year <- 1970
gapminder %>% filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black")

# be more useful to see which countries are very poor by using log base 2
# 1 -> extremely poor
# 2 _> very poor
# 4 -> somewhat poor
# 8 - > middle
# 16 -> well off
# 32 -> rich
# 64 -> extremely rich

past_year <- 1970
gapminder %>% filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(log2(dollars_per_day))) +
  geom_histogram(binwidth = 1, color = "black")

# repeat histogram with log2 scaled x-axis
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2")