library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
set.seed(1)

# In general, we can extract data directly from Twitter using the rtweet package. 
# However, in this case, a group has already compiled data for us and made it 
# available at http://www.trumptwitterarchive.com
url <- 'http://www.trumptwitterarchive.com/data/realdonaldtrump/%s.json'
trump_tweets <- map(2009:2017, ~sprintf(url, .x)) %>%
  map_df(jsonlite::fromJSON, simplifyDataFrame = TRUE) %>%
  filter(!is_retweet & !str_detect(text, '^"')) %>%
  mutate(created_at = parse_date_time(created_at, orders = "a b! d! H!:M!:S! z!* Y!", tz="EST"))

# library(dslabs)
# data("trump_tweets")

# This is data frame with information about the tweet:
head(trump_tweets)

# The variables that are included are:
names(trump_tweets)


#tweets are represented by the text variable
trump_tweets %>% select(text) %>% head

#source variable tells us the device used to send each tweet
trump_tweets %>% count(source) %>% arrange(desc(n))

# use extract to remove the 'Twitter for' part of the source and filter out retweets.
trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  count(source) 

# We are interested in what happened during the campaign, so for the analysis 
# here we will focus on what was tweeted between the day Trump announced his 
# campaign and election day. So we define the following table:
campaign_tweets <- trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  filter(source %in% c("Android", "iPhone") &
           created_at >= ymd("2015-06-17") & 
           created_at < ymd("2016-11-08")) %>%
  filter(!is_retweet) %>%
  arrange(created_at)




# We can now use data visualization to explore the possibility that two different 
# groups were tweeting from these devices. For each tweet, we will extract the 
# hour, in the east coast (EST), it was tweeted then compute the proportion of 
# tweets tweeted at each hour for each device.
ds_theme_set()
campaign_tweets %>%
  mutate(hour = hour(with_tz(created_at, "EST"))) %>%
  count(source, hour) %>%
  group_by(source) %>%
  mutate(percent = n / sum(n)) %>%
  ungroup %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Hour of day (EST)",
       y = "% of tweets",
       color = "")

# we see that there is a clear difference in patterns of tweets between the two
# different devices.
# we want to study how their tweets differ

library(tidytext)

example <- data_frame(line = c(1, 2, 3, 4),
                      text = c("Roses are red,", "Violets are blue,", "Sugar is sweet,", "And so are you."))
example
example %>% unnest_tokens(word, text)



# looking at campaign tweet 3008
i <- 3008
campaign_tweets$text[i]
campaign_tweets[i,] %>% 
  unnest_tokens(word, text) %>%
  select(word)
# Note that the function tries to convert tokens into words and strips 
# characters important to twitter such as # and @. 

# instead of using the default token, words, we define a regex that captures 
# twitter character. The pattern appears complex but all we are defining is 
# a patter that starts with @, # or neither and is followed by any combination 
# of letters or digits:
pattern <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"


campaign_tweets[i,] %>% 
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  select(word)


### we also want to remove links to pictures
campaign_tweets[i,] %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  select(word)

# now extracting the words for all of the tweets
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) 




# most commonly used words?
tweet_words %>% 
  count(word) %>%
  arrange(desc(n))


#filtering out stop words
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word) 

#new list of top words
tweet_words %>% 
  count(word) %>%
  top_n(10, n) %>%
  mutate(word = reorder(word, n)) %>%
  arrange(desc(n))

# some of our tokens are just dates so we want to remove these. 
# also want to remove the ' for words that come from a quote
tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word &
           !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))


# For each word we want to know if it is more likely to come from an 
# Android tweet or an iPhone tweet.
# Computing the odds ratio. proportion of words that are y  and not y
# Because we have many ratios that are 0 we need a 0.5 correction
android_iphone_or <- tweet_words %>%
  count(word, source) %>%
  spread(source, n, fill = 0) %>%
  mutate(or = (Android + 0.5) / (sum(Android) - Android + 0.5) / 
           ( (iPhone + 0.5) / (sum(iPhone) - iPhone + 0.5)))
android_iphone_or %>% arrange(desc(or))
android_iphone_or %>% arrange(or)




# Given that several of these words are overall low frequency words we can 
# impose a filter based on the total frequency like this:
android_iphone_or %>% filter(Android+iPhone > 100) %>%
  arrange(desc(or))

android_iphone_or %>% filter(Android+iPhone > 100) %>%
  arrange(or)



# using sentiment analysis to analyze the tweets.
# different lexicons rate sentiments differently (take a look below)
library("tidytext")
library("textdata")
get_sentiments("bing")
get_sentiments("afinn")
get_sentiments("loughran") %>% count(sentiment)
get_sentiments("nrc") %>% count(sentiment)

# For the analysis here we are interested in exploring the different sentiments 
# of each tweet, so we will use the nrc lexicon:
nrc <- get_sentiments("nrc") %>%
  select(word, sentiment)

# we can combine words and sentiments using inner join which
# will only keep words associated with a sentiment
tweet_words %>% inner_join(nrc, by = "word") %>% 
  select(source, word, sentiment) %>% sample_n(10)

# we could do a tweet by tweet analysis of sentiments but this would be much more
# difficult.  instead we will count and compare the sentiment words have on each device
sentiment_counts <- tweet_words %>%
  left_join(nrc, by = "word") %>%
  count(source, sentiment) %>%
  spread(source, n) %>%
  mutate(sentiment = replace_na(sentiment, replace = "none"))
sentiment_counts

tweet_words %>% group_by(source) %>% summarize(n = n())



# for each sentiment we can compute the odds of being in the device: proportion 
# of words with sentiment versus proportion of words without and then compute 
# the odds ratio comparing the two devices:
sentiment_counts %>%
  mutate(Android = Android / (sum(Android) - Android) , 
         iPhone = iPhone / (sum(iPhone) - iPhone), 
         or = Android/iPhone) %>%
  arrange(desc(or))



# So we do see some difference and the order is interesting: the largest three 
# sentiments are disgust, anger, and negative! But are they statistically 
# significant? How does this compare if we are just assigning sentiments at random?
#   
# To answer that question we can compute, for each sentiment, an odds ratio 
# and confidence interval. We will add the two values we need to form a two-by-two 
# table and the odds ratio:


log_or <- sentiment_counts %>%
  mutate( log_or = log( (Android / (sum(Android) - Android)) / (iPhone / (sum(iPhone) - iPhone))),
          se = sqrt( 1/Android + 1/(sum(Android) - Android) + 1/iPhone + 1/(sum(iPhone) - iPhone)),
          conf.low = log_or - qnorm(0.975)*se,
          conf.high = log_or + qnorm(0.975)*se) %>%
  arrange(desc(log_or))

log_or

log_or %>%
  mutate(sentiment = reorder(sentiment, log_or),) %>%
  ggplot(aes(x = sentiment, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point(aes(sentiment, log_or)) +
  ylab("Log odds ratio for association between Android and sentiment") +
  coord_flip() 



# We see that the disgust, anger, negative sadness and fear sentiments are 
# associated with the Android in a way that is hard to explain by chance alone. 
# Words not associated to a sentiment were strongly associated with the iPhone 
# source, which is in agreement with the original claim about hyperbolic tweets.
# 
# If we are interested in exploring which specific words are driving these 
# differences, we can back to our android_iphone_or object:
android_iphone_or %>% inner_join(nrc) %>%
  filter(sentiment == "disgust" & Android + iPhone > 10) %>%
  arrange(desc(or))

android_iphone_or %>% inner_join(nrc, by = "word") %>%
  mutate(sentiment = factor(sentiment, levels = log_or$sentiment)) %>%
  mutate(log_or = log(or)) %>%
  filter(Android + iPhone > 10 & abs(log_or)>1) %>%
  mutate(word = reorder(word, log_or)) %>%
  ggplot(aes(word, log_or, fill = log_or < 0)) +
  facet_wrap(~sentiment, scales = "free_x", nrow = 2) + 
  geom_bar(stat="identity", show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

