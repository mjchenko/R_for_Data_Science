library(tidyverse)
library(dslabs)
data("mnist_27")

library(caret)
#caret package does not automatically load all the models.  
# You still will need to load these packages
# 
# http://topepo.github.io/caret/available-models.html External link
# http://topepo.github.io/caret/train-models-by-tag.html External link

train_glm <- train(y ~ ., method = "glm", data = mnist_27$train)
train_knn <- train(y ~ ., method = "knn", data = mnist_27$train)

y_hat_glm <- predict(train_glm, mnist_27$test, type = "raw")
y_hat_knn <- predict(train_knn, mnist_27$test, type = "raw")

confusionMatrix(y_hat_glm, mnist_27$test$y)$overall[["Accuracy"]]
confusionMatrix(y_hat_knn, mnist_27$test$y)$overall[["Accuracy"]]