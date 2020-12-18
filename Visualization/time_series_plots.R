library(dslabs)
library(ggplot2)
data(gapminder)

#make plot of US fertility rate over the years
ds_theme_set()
filter(gapminder, country %in% "United States") %>% 
  ggplot(aes(year, fertility)) + 
  geom_point()

# because data has a lot of points and all from one country use a line
ds_theme_set()
filter(gapminder, country %in% "United States") %>% 
  ggplot(aes(year, fertility)) + 
  geom_line()

# lets look at one country from europe and asia
countries <- c("South Korea", "Germany")
ds_theme_set()
filter(gapminder, country %in% countries) %>% 
  ggplot(aes(year, fertility)) + 
  geom_line() +
  facet_grid(.~country)

# or assign a group for the data to be shown on the same plot for each respective
# country. This however does not label either line so you cant distinguish
ds_theme_set()
filter(gapminder, country %in% countries) %>% 
  ggplot(aes(year, fertility, group = country)) + 
  geom_line()

# when you use color it will automatically group them by what you used in color
ds_theme_set()
filter(gapminder, country %in% countries) %>% 
  ggplot(aes(year, fertility, color = country)) + 
  geom_line()


# show how to use labels instead of legends
# create dataframe for label locations
labels <- data.frame(country = countries, x = c(1975, 1965), y = c(60, 72))

#create plot with labels
ds_theme_set()
gapminder %>% filter(country %in% countries) %>% 
  ggplot(aes(year, life_expectancy, color = country)) + 
  geom_line() + 
  geom_text(data = labels, aes(x, y, label = country), size = 5) + 
  theme(legend.position ="none")

