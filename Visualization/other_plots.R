# male height plots
library(ggthemes)
library(ggrepel)
library(dslabs)
data(heights)

# define p to be the Male dataset you want
p <- heights %>% filter(sex == "Male") %>%
  ggplot(aes(x = height))

# makes histogram
p + geom_histogram(binwidth = 1, fill = "blue", col = "black") +
  xlab("Male Height in Inches") + 
  ggtitle("Histogram")

# make smooth density plot
p + geom_density(fill = "blue")



# redefine p to be the Male dataset you want
# need to redefine it because qq plot takes sample as the argument
p <- heights %>% filter(sex == "Male") %>%
  ggplot(aes(sample = height))

# ge sd and mean of the dataset
params <- heights %>% filter(sex == "Male") %>% 
  summarize(mean = mean(height), sd = sd(height))

# make qq plot
p + geom_qq(dparams = params) + geom_abline()

# could also scale the plot so we dont have to calc mean and sd and make code 
# cleaner
heights %>% filter(sex == "Male") %>% 
  ggplot(aes(sample = scale(height))) + 
  geom_qq() + 
  geom_abline()

# produce multiple plots shown together
p <- heights %>% filter(sex == "Male") %>% ggplot(aes(x = height))
p1 = p + geom_histogram(binwidth = 1, fill = "blue", col = "black")
p2 = p + geom_histogram(binwidth = 2, fill = "blue", col = "black")
p3 = p + geom_histogram(binwidth = 3, fill = "blue", col = "black")
library(gridExtra)
grid.arrange(p1, p2, p3, ncol = 3)