library(ggthemes)
library(ggrepel)
library(dslabs)
data(murders)

# add points layer to predefined ggplot object
##p <- ggplot(data = murders)
##p + geom_point(aes(population/10^6, total))

# add text layer to scatterplot
## p + geom_point(aes(population/10^6, total)) +
##   geom_text(aes(population/10^6, total, label = abb))

# no error from this call
##p_test <- p + geom_text(aes(population/10^6, total, label = abb))

# error - "abb" is not a globally defined variable and cannot be found outside of aes
##p_test <- p + geom_text(aes(population/10^6, total), label = abb)


# change the size of points on scatter plot and nudge the text away from the point
## p + geom_point(aes(population/10^6, total), size = 3) +
##   geom_text(aes(population/10^6, total, label = abb), nudge x = 1)


# use a global aes call to make it cleaner
## p <- ggplot(data = murders, aes(population/10^6, total, label = abb))
## p + geom_point(size = 3) + geom_text(nudge_x = 1.5)

# could have also simplified code by running this through pipe
## p <- murders %>% ggplot(aes(population/10^6, total, label = abb))
## p + geom_point(size = 3) +
##   geom_text(nudge_x = 1.5)

# scale x and y axis
## p <- ggplot(data = murders, aes(population/10^6, total, label = abb))
## p + geom_point(size = 3) +
##   + geom_text(nudge_x = 0.075) + 
##  + scale_x_continuous(trans = "log10") +
##  + scale_y_continuous(trans = "log10")

# more simply
p <- ggplot(data = murders, aes(population/10^6, total, label = abb))
p + geom_point(size = 3) +
  + geom_text(nudge_x = 0.075) + 
  + scale_x_log10()+
  + scale_y_log10()

# add labels and title
p <- ggplot(data = murders, aes(population/10^6, total, label = abb))
p <- p + geom_point(size = 3) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

# change color of points, blue first then by region
# make all points blue
p + geom_point(size = 3, color = "blue")

# color points by region
p + geom_point(aes(col = region), size = 3)

# define average murder rate
r <- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)

# basic line with average murder rate for the country ab line takes 
# arguments for slope and intercept Here we only define intercept because slope 
# default 1 but intercept is default 0
p + geom_point(aes(col = region), size = 3) +
  geom_abline(intercept = log10(r))    # slope is default of 1

# change line to dashed and dark grey, line under points because abline called
# before 
p <- p + 
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col = region), size = 3) + 
  scale_color_discrete(name = "Region")

p + theme_economist()

