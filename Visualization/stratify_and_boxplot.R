library(dslabs)
library(ggplot2)
data(gapminder)

past_year <- 1970
gapminder <- gapminder %>% mutate(dollars_per_day = gdp/population/365)

p <- gapminder %>% 
  filter(year == past_year & !is.na(gdp)) %>% 
  ggplot(aes(region, dollars_per_day))

# cant read axis labels
p + geom_boxplot()

#adjsut labels
p + geom_boxplot() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


## example showing how to use reorder function
# by default, factor order is alphabetical
fac <- factor(c("Asia", "Asia", "West", "West", "West"))
levels(fac)

# reorder factor by the category means
value <- c(10, 11, 12, 6, 4)
fac <- reorder(fac, value, FUN = mean)
levels(fac)

# reorder by median income and color by continent
p <- gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%    # reorder
  ggplot(aes(region, dollars_per_day, fill = continent)) +    # color by continent
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("")

p

#transform y axis to log scale to show better
p <- p + scale_y_continuous(trans = "log2")
p

# add points if you want 
p <- p + geom_point(show.legend = FALSE)
p