library(dplyr)
library(dslabs)

data(murders)
data(heights)
murders <- murders %>% mutate(murder_rate = total / population * 100000)
murders %>% arrange(population) %>% head()
murders %>% arrange(murder_rate) %>% head()

# arrange sorts by default in ascending order
# to get descending order
murders %>% arrange(desc(murder_rate)) %>% head()

#nested sorting

#order by region, and then within each region by murder rate
murders %>% arrange(region, murder_rate) %>% head()

# want to see a larger proportion of results use
# top_n function
# note these are not ordered
murders %>% top_n(10, murder_rate)

# to get them in order
murders %>% arrange(desc(murder_rate)) %>% top_n(10)