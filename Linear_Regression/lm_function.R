library(HistData)
data("GaltonFamilies")
set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# fit regression line to predict son's height from father's height
# y = bo + b1x
# y is the sons height, x is the dads height
# lm function value trying to predict ~ value using to predict
fit <- lm(son ~ father, data = galton_heights)
fit

# summary statistics
summary(fit)