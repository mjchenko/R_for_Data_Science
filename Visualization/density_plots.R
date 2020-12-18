library(dslabs)
library(ggplot2)
data(gapminder)

#add dollars_per_day
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp/population/365)

#comparison years
past_year <- 1970
present_year <- 2010

# define countries that have data available in both years
# interset is used to find these countries
country_list_1 <- gapminder %>%
  filter(year == past_year & !is.na(dollars_per_day)) %>% .$country
country_list_2 <- gapminder %>%
  filter(year == present_year & !is.na(dollars_per_day)) %>% .$country
country_list <- intersect(country_list_1, country_list_2)

#define west
west <- c("Western Europe", "Northern Europe", "Southern Europe", "Northern America", "Australia and New Zealand")

# this was just put in to show the differences in group sizes
gapminder %>%
  filter(year == past_year & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>% group_by(group) %>%
  summarize(n = n()) %>% knitr::kable()

p <- gapminder %>% 
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(x = dollars_per_day, y = ..count.., fill = group)) + 
  scale_x_continuous(trans = "log2") + 
  geom_density(alpha = 0.2, bw = 0.75) + facet_grid(year~.)

p



# make other regions to group 
east_asia = c("Eastern Asia", "South-Eastern Asia")
latin_amer = c("Caribbean", "Central America", "South America")

# add group as a factor, grouping regions
gapminder <- gapminder %>%
  mutate(group = case_when(
    .$region %in% west ~ "West",
    .$region %in% east_asia ~ "East Asia",
    .$region %in% latin_amer ~ "Latin America",
    .$continent == "Africa" & .$region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others"))

# reorder factor levels
gapminder <- gapminder %>%
  mutate(group = factor(group, levels = c("Others", "Latin America", "East Asia", "Sub-Saharan Africa", "West")))

# remake plots with new groups
p <- gapminder %>% 
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  ggplot(aes(x = dollars_per_day, y = ..count.., fill = group)) + 
  scale_x_continuous(trans = "log2") + 
  geom_density(alpha = 0.2, bw = 0.75) + facet_grid(year~.)

p

#make plot easier to read by stacking
p + geom_density(alpha = 0.2, bw = 0.75, position = "stack")


# weighted stacked density plot for population
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  group_by(year) %>%
  mutate(weight = population/sum(population*2)) %>%
  ungroup() %>%
  ggplot(aes(dollars_per_day, fill = group, weight = weight)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") + facet_grid(year ~ .)
