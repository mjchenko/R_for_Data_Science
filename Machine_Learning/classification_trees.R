library(dslabs)
library(caret)
data("mnist_27")

##for a categorical outcome (i.e. in this case 2 or 7)

# fit a classification tree and plot it
# cp is the complexity parameter
train_rpart <- train(y ~ .,
                     method = "rpart",
                     tuneGrid = data.frame(cp = seq(0.0, 0.1, len = 25)),
                     data = mnist_27$train)
plot(train_rpart)

# compute accuracy
confusionMatrix(predict(train_rpart, mnist_27$test), mnist_27$test$y)$overall["Accuracy"]