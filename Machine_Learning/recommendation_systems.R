library(dslabs)
library(tidyverse)
data("movielens")

head(movielens)

movielens %>%
  summarize(n_users = n_distinct(userId),
            n_movies = n_distinct(movieId))

keep <- movielens %>%
  dplyr::count(movieId) %>%
  top_n(5) %>%
  pull(movieId)
tab <- movielens %>%
  filter(userId %in% c(13:20)) %>% 
  filter(movieId %in% keep) %>% 
  select(userId, title, rating) %>% 
  spread(title, rating)
tab %>% knitr::kable()

#not every user rates every movie.  Their ratings are sparse
users <- sample(unique(movielens$userId), 100)
rafalib::mypar()
movielens %>% filter(userId %in% users) %>% 
  select(userId, movieId, rating) %>%
  mutate(rating = 1) %>%
  spread(movieId, rating) %>% select(sample(ncol(.), 100)) %>% 
  as.matrix() %>% t(.) %>%
  image(1:100, 1:100,. , xlab="Movies", ylab="Users")
abline(h=0:100+0.5, v=0:100+0.5, col = "grey")

#some movies get more ratings than others.
#this makes sense becase some movies are more popular than others
movielens %>% 
  dplyr::count(movieId) %>% 
  ggplot(aes(n)) + 
  geom_histogram(bins = 30, color = "black") + 
  scale_x_log10() + 
  ggtitle("Movies")

#some users rate movies more often than others.
movielens %>%
  dplyr::count(userId) %>% 
  ggplot(aes(n)) + 
  geom_histogram(bins = 30, color = "black") + 
  scale_x_log10() +
  ggtitle("Users")

#create a test and train set
library(caret)
set.seed(755)
test_index <- createDataPartition(y = movielens$rating, times = 1,
                                  p = 0.2, list = FALSE)
train_set <- movielens[-test_index,]
test_set <- movielens[test_index,]

# to make sure we dont include users and movies that dont appear in the test set
# that are in the training set
test_set <- test_set %>% 
  semi_join(train_set, by = "movieId") %>%
  semi_join(train_set, by = "userId")


#write a function that computes RMSE for a vector of ratings and predicted ratings
RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}



#building the simplest model
#i.e. the model that predicts the same rating for all movies (the avg)
mu_hat <- mean(train_set$rating)
mu_hat
#rmse of about 1.05 is greater than 1 so not a good prediction
naive_rmse <- RMSE(test_set$rating, mu_hat)
naive_rmse
#if you plug in any number other than the avg you get a RMSE higher than 1.05
predictions <- rep(2.5, nrow(test_set))
RMSE(test_set$rating, predictions)

rmse_results <- data_frame(method = "Just the average", RMSE = naive_rmse)

# fit <- lm(rating ~ as.factor(userId), data = movielens)

#calculate the bias for each movie rating by subtracting the rating - mu
#because some movies are generally higher rated, and other movies are generally
#lower rated
mu <- mean(train_set$rating) 
movie_avgs <- train_set %>% 
  group_by(movieId) %>% 
  summarize(b_i = mean(rating - mu))

movie_avgs %>% qplot(b_i, geom ="histogram", bins = 10, data = ., color = I("black"))

predicted_ratings <- mu + test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  .$b_i

model_1_rmse <- RMSE(predicted_ratings, test_set$rating)
rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie Effect Model",
                                     RMSE = model_1_rmse ))

rmse_results %>% knitr::kable()

#not all users rate the same way, some rate all movies high, some all movies low, 
# and some in the middle
train_set %>% 
  group_by(userId) %>% 
  summarize(b_u = mean(rating)) %>% 
  filter(n()>=100) %>%
  ggplot(aes(b_u)) + 
  geom_histogram(bins = 30, color = "black")

# lm(rating ~ as.factor(movieId) + as.factor(userId))

#we also need to calculate the bias for each user
#we do this by taking the rating and subtracting the average and movie bias
user_avgs <- test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  group_by(userId) %>%
  summarize(b_u = mean(rating - mu - b_i))

predicted_ratings <- test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  left_join(user_avgs, by='userId') %>%
  mutate(pred = mu + b_i + b_u) %>%
  .$pred

model_2_rmse <- RMSE(predicted_ratings, test_set$rating)

rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie + User Effects Model",  
                                     RMSE = model_2_rmse ))
rmse_results %>% knitr::kable()




####### from assessment 
# we can also see a time effect on the movie rating
library(lubridate)
movielens <- mutate(movielens, date = as_datetime(timestamp))
movielens <- movielens %>% mutate(week = round_date(date, unit = "week"))
movielens %>%
  group_by(week) %>%
  summarize(rating = mean(rating)) %>%
  ggplot(aes(week, rating)) +
  geom_point() +
  geom_smooth()

#trying to fit week loess to see if it is same plot as above
fit <- loess(rating ~ timestamp, data = movielens)

movielens %>% mutate(smooth = fit$fitted) %>%
  ggplot(aes(timestamp, rating)) +
  geom_point(size = 3, alpha = .5, color = "grey") +
  geom_line(aes(timestamp, smooth), color="red") + scale_x_log10()


# lets try to add this to predictor
time <- test_set %>% mutate(week = round_date(date, unit = "week")) %>%
  left_join(movie_avgs, by='movieId') %>%
  left_join(user_avgs, by='userId') %>%
  group_by(week) %>%
  summarize(b_w = mean(rating - mu - b_i - b_u))


predicted_ratings <- test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  left_join(user_avgs, by='userId') %>%
  left_join(time, by='week') %>%
  mutate(pred = mu + b_i + b_u + b_w) %>%
  .$pred

#there are 5 with NA results (likely due to no timestamp)
sum(is.na(predicted_ratings))
ind <- which(is.na(predicted_ratings))
#replace these with mu
new_p_r <- ifelse(is.na(predicted_ratings), mu, predicted_ratings)

model_3_rmse <- RMSE(new_p_r, test_set$rating)

rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie + User + time Effects Model",  
                                     RMSE = model_3_rmse ))
rmse_results %>% knitr::kable()
#doesnt change much


# we can also see a genre affect
movielens %>% group_by(genres) %>%
  summarize(n = n(), avg = mean(rating), stdev = sd(rating), se = sd(rating)/sqrt(n())) %>%
  filter(n > 1000) %>% 
  ggplot(aes(x = genres, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
  geom_bar (stat = "identity", fill = "skyblue", alpha = 0.7) + 
  geom_errorbar(width=0.4, colour="orange", alpha=0.9, size=1.3) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
########