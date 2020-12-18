library(tidyverse)
library(dslabs)
library(caret)
data("mnist_27")

#showing all the data
mnist_27$test %>% ggplot(aes(x_1, x_2, color = y)) + geom_point()


#logistic regression as the baseline we are trying to beat
fit_glm <- glm(y~x_1+x_2, data=mnist_27$train, family="binomial")
p_hat_logistic <- predict(fit_glm, mnist_27$test)
y_hat_logistic <- factor(ifelse(p_hat_logistic > 0.5, 7, 2))
confusionMatrix(data = y_hat_logistic, reference = mnist_27$test$y)$overall[1]

#fit knn model (~ . means use all predictors in the data set. i.e. x_1 + x_2)
knn_fit <- knn3(y ~ ., data = mnist_27$train)

## we could also fit using this method
# the train data set has two predictors x_1 and x_2. putting these in x
x <- as.matrix(mnist_27$train[,2:3])
#putting the actual number (2,7) in y
y <- mnist_27$train$y
##example how to fit
#fitting using knn3 (in caret package)
knn_fit <- knn3(x,y)

# k is the number of nearest neighbors. The default is 5 but we write explicitly
knn_fit <- knn3(y ~ ., data = mnist_27$train, k=5)

# type = "class" means it will give the actual prediction (2 or 7) instead of the probability
y_hat_knn <- predict(knn_fit, mnist_27$test, type = "class")
confusionMatrix(data = y_hat_knn, reference = mnist_27$test$y)$overall["Accuracy"]





###overtraining and oversmoothing
# we see that when we test accuracy on the train set it is higher than on the 
# test set indicating over training
y_hat_knn <- predict(knn_fit, mnist_27$train, type = "class") 
confusionMatrix(data = y_hat_knn, reference = mnist_27$train$y)$overall["Accuracy"]
y_hat_knn <- predict(knn_fit, mnist_27$test, type = "class")  
confusionMatrix(data = y_hat_knn, reference = mnist_27$test$y)$overall["Accuracy"]

#fit knn with k=1
# when k = 1 it only takes the one current point so it should be perfect training on the train set
# but this will not be accurate on the test set due to overtraining
knn_fit_1 <- knn3(y ~ ., data = mnist_27$train, k = 1)
#train set
y_hat_knn_1 <- predict(knn_fit_1, mnist_27$train, type = "class")
confusionMatrix(data=y_hat_knn_1, reference=mnist_27$train$y)$overall[["Accuracy"]]
#test set
y_hat_knn_1 <- predict(knn_fit_1, mnist_27$test, type = "class")
confusionMatrix(data=y_hat_knn_1, reference=mnist_27$test$y)$overall[["Accuracy"]]

#fit knn with k=401
#larger k will lead to more smoothing but too large of a k will lead to almost linear behavior
#because it considers too many points
knn_fit_401 <- knn3(y ~ ., data = mnist_27$train, k = 401)
y_hat_knn_401 <- predict(knn_fit_401, mnist_27$test, type = "class")
confusionMatrix(data=y_hat_knn_401, reference=mnist_27$test$y)$overall["Accuracy"]

#pick the k in knn
ks <- seq(3, 251, 2)
library(purrr)
accuracy <- map_df(ks, function(k){
  fit <- knn3(y ~ ., data = mnist_27$train, k = k)
  y_hat <- predict(fit, mnist_27$train, type = "class")
  cm_train <- confusionMatrix(data = y_hat, reference = mnist_27$train$y)
  train_error <- cm_train$overall["Accuracy"]
  y_hat <- predict(fit, mnist_27$test, type = "class")
  cm_test <- confusionMatrix(data = y_hat, reference = mnist_27$test$y)
  test_error <- cm_test$overall["Accuracy"]
  
  tibble(train = train_error, test = test_error)
})


#pick the k that maximizes accuracy using the estimates built on the test data
ks[which.max(accuracy$test)]
max(accuracy$test)