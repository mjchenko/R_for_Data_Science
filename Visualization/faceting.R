library(dslabs)
library(ggplot2)
data(gapminder)


# side by side plots are preferrable to make comparisons.
# to do this we will facet the data by some variables in this case the year
# we will use facet_grid (lets you facet by 2 variables)

#here we facet by continent and year.  continent is the rows, years the columns
ds_theme_set()
filter(gapminder, year %in% c(1962, 2012)) %>% 
  ggplot(aes(fertility, life_expectancy, color = continent)) + 
  geom_point() +
  facet_grid(continent~year)

#really we want to facet just by year 
ds_theme_set()
filter(gapminder, year %in% c(1962, 2012)) %>% 
  ggplot(aes(fertility, life_expectancy, color = continent)) + 
  geom_point() +
  facet_grid(.~year)

#lets compare europe and aisa over multiple years
years <- c(1962, 1980, 1990, 2000, 2012)
continents <- c("Europe", "Asia")

#facet_wrap makes it so all the plots dont show up on one row so we can see the
#data more clearly

#facet also keeps the range the same across all plots so that it makes 
#comparisons easier across plots. if plotted separately the scales would change
ds_theme_set()
filter(gapminder, year %in% years, continent %in% continents) %>% 
  ggplot(aes(fertility, life_expectancy, color = continent)) + 
  geom_point() +
  facet_wrap(~year)