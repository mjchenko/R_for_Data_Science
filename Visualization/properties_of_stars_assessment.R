library(tidyverse)
library(dslabs)
data(stars)
options(digits = 3)   # report 3 significant digits

stars %>% summarize(mean_mag = mean(magnitude), stdev_mag = sd(magnitude))

stars %>% ggplot(aes(x = magnitude)) + geom_density()

stars %>% ggplot(aes(x = temp)) + geom_density() 

stars %>% ggplot(aes(x = temp, y = magnitude)) + geom_point()

library("scales")
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

stars %>% ggplot(aes(x = temp, y = magnitude, label = star)) + 
  geom_point() + 
  scale_y_reverse() + 
  scale_x_continuous(trans = reverselog_trans(10))

stars %>% ggplot(aes(x = temp, y = magnitude, label = star)) + 
  geom_point() + 
  scale_y_reverse() + 
  scale_x_reverse() + geom_text_repel()


stars %>% ggplot(aes(x = temp, y = magnitude, color = type, label = type)) 
  + geom_point()
  + geom_text()
  scale_y_reverse() + 
  scale_x_reverse() + scale_fill_brewer(palette = "Set1")