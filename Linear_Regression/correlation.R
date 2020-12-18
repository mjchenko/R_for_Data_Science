library(HistData)
data("GaltonFamilies")
galton_heights <- GaltonFamilies %>% 
  filter(childNum == 1 & gender == "male") %>% 
  select(father, childHeight) %>%
  rename(son = childHeight)

# means and standard deviations
# data should be normal so this is valid approx
galton_heights %>%
  summarize(mean(father), sd(father), mean(son), sd(son))

# scatterplot of father and son heights
# scatterplot shows a clear correlation between father and son heights
galton_heights %>%
  ggplot(aes(father, son)) +
  geom_point(alpha = 0.5)

#unrelated variables will have a correlation ~ 0
# if quantities vary together, we will get a positive correlation
# if they vary in opposite directions, we will get a negative correlation
# correlation coeff is always between -1 and 1

galton_heights %>% summarize(cor(father, son))