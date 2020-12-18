library(dplyr)
library(dslabs)

data(heights)
heights %>% ggplot(aes(sex, height)) + geom_point()

# jittered, alpha blended point plot because it is hard to see all the points
# stacked on top of each other
heights %>% ggplot(aes(sex, height)) + geom_jitter(width = 0.1, alpha = 0.2)

# however a distribution would be better for this
# align plots vertically to see horizontal changes
# align plots horizontally to see vertical changes
heights %>% ggplot(aes(x = height, y = ..density.., fill = sex)) + geom_histogram(show.legend = FALSE) + facet_grid(sex~.)