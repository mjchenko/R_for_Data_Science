library(HistData)
data("GaltonFamilies")
galton_heights <- GaltonFamilies %>% 
  filter(childNum == 1 & gender == "male") %>% 
  select(father, childHeight) %>%
  rename(son = childHeight)

# When two variables follow a bivariate normal distribution, computing the 
# regression line is equivalent to computing conditional expectations.
# We can obtain a much more stable estimate of the conditional expectation by 
# finding the regression line and using it to make predictions.

#stratify the data based on the scaled fathers height to ensure that the normal
#assumption holds for each range of father/son heights

galton_heights %>%
  mutate(z_father = round((father - mean(father)) / sd(father))) %>%
  filter(z_father %in% -2:2) %>%
  ggplot() +  
  stat_qq(aes(sample = son)) +
  facet_wrap( ~ z_father)

