library(dslabs)
data(gapminder)
head(gapminder)

gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey", "Poland", 
                                       "South Korea", "Malaysia", "Russia",
                                       "Pakistan", "Vietnam", "Thailand",
                                       "South Africa")) %>%
  select(country, infant_mortality)

ds_theme_set()
filter(gapminder, year == 1962) %>% 
  ggplot(aes(fertility, life_expectancy, color = continent)) + 
  geom_point()