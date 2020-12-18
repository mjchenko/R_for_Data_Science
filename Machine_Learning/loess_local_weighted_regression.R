library(dslabs)
library(tidyverse)
data("polls_2008")

total_days <- diff(range(polls_2008$day))
#loess takes a proportion for span and takes that N*proportion nearest points for fit
span <- 21/total_days

fit <- loess(margin ~ day, degree=1, span = span, data=polls_2008)

polls_2008 %>% mutate(smooth = fit$fitted) %>%
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "grey") +
  geom_line(aes(day, smooth), color="red")

# the default of loess is to fit parabolas but we specified degree equal 1 above
#when using parabolas we can use a larger span
total_days <- diff(range(polls_2008$day))
span <- 28/total_days

fit_1 <- loess(margin ~ day, degree=1, span = span, data=polls_2008)

fit_2 <- loess(margin ~ day, span = span, data=polls_2008)


polls_2008 %>% mutate(smooth_1 = fit_1$fitted, smooth_2 = fit_2$fitted) %>%
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "grey") +
  geom_line(aes(day, smooth_1), color="red", lty = 2) +
  geom_line(aes(day, smooth_2), color="orange", lty = 1) 

#also note that ggplot geom_smooth uses loess for its smooth line but has default parameters
polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth()

#we can change those default parameters easily
polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(method = "loess", span = 0.15, method.args = list(degree=1))