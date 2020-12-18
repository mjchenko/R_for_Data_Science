library(ggthemes)
library(ggrepel)
library(dslabs)
data(murders)

## define slope of the line
r <- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)

murders %>% ggplot(aes(population/10^6, total, label = abb)) +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") + 
  geom_point(aes(color = region), size = 3) + 
  geom_text_repel() + 
  scale_x_log10() + 
  scale_y_log10() + 
  xlab("Populations in millions (log scale)") +
  ylab("Populations in millions (log scale)") + 
  ggtitle("US Gun Murders in 2010") + 
  scale_color_discrete(name = "Region") + 
  theme_economist()