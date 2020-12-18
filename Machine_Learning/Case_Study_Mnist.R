library(dslabs)
mnist <- read_mnist()

names(mnist)
dim(mnist$train$images)

class(mnist$train$labels)
table(mnist$train$labels)

# sample 10k rows from training set, 1k rows from test set
set.seed(123)
index <- sample(nrow(mnist$train$images), 10000)
x <- mnist$train$images[index,]
y <- factor(mnist$train$labels[index])

index <- sample(nrow(mnist$test$images), 1000)
#note that the line above is the corrected code - code in video at 0:52 is incorrect
x_test <- mnist$test$images[index,]
y_test <- factor(mnist$test$labels[index])


library(matrixStats)
#looking for columns with near non-zero variance to remove
sds <- colSds(x)
qplot(sds, bins = 256, color = I("black"))

library(caret)
# looking for columns with near non-zero variance to remove (whitespace)
nzv <- nearZeroVar(x)
image(matrix(1:784 %in% nzv, 28, 28))
#getting the columns that have variance to use as predictors
col_index <- setdiff(1:ncol(x), nzv)
length(col_index)

#adding names to the columns in the feature matrices (required by caret)
colnames(x) <- 1:ncol(mnist$train$images)

#doing knn approach using cross validation to find model that will optimize code
control <- trainControl(method = "cv", number = 10, p = .9)
train_knn <- train(x[,col_index], y,
                   method = "knn", 
                   tuneGrid = data.frame(k = c(1,3,5,7)),
                   trControl = control)
colnames(x_test) <- colnames(x)

ggplot(train_knn)

#running code on a smaller subset of data to see how long final code will take
n <- 1000 # n number of rows used
b <- 2 #b number of cross validations
index <- sample(nrow(x), n) #randomly sampling rows n times
control <- trainControl(method = "cv", number = b, p = .9) # set parameters
train_knn <- train(x[index ,col_index], y[index],
                   method = "knn",
                   tuneGrid = data.frame(k = c(3,5,7)),
                   trControl = control) #running on a smaller set to pick k

#fitting entire dataset
fit_knn <- knn3(x[ ,col_index], y,  k = 3) #running knn on entire dataset with the k from above

y_hat_knn <- predict(fit_knn,
                     x_test[, col_index],
                     type="class")
cm <- confusionMatrix(y_hat_knn, factor(y_test))
cm$overall["Accuracy"]

cm$byClass[,1:2] # we see 8 is the worst at being detected (lowest sensitivity)
# and the one with the lowest specificty is most commonly incorrect predicted digit is 7

#running random forest
library(Rborist)
#because fitting is slowest part rather than predicting, we will only use 5 fold cv
control <- trainControl(method="cv", number = 5, p = 0.8)
grid <- expand.grid(minNode = c(1,5) , predFixed = c(10, 15, 25, 35, 50))
train_rf <-  train(x[, col_index], y,
                   method = "Rborist",
                   nTree = 50,
                   trControl = control,
                   tuneGrid = grid,
                   nSamp = 5000) #random subset of observations when constructing each tree
                                #reduce number of trees nTree fit because we are not building final model
ggplot(train_rf)
#choose parameters 
train_rf$bestTune

fit_rf <- Rborist(x[, col_index], y,
                  nTree = 1000,
                  minNode = train_rf$bestTune$minNode,
                  predFixed = train_rf$bestTune$predFixed) #using more trees and our optimized parameters

y_hat_rf <- factor(levels(y)[predict(fit_rf, x_test[ ,col_index])$yPred])
cm <- confusionMatrix(y_hat_rf, y_test)
cm$overall["Accuracy"]

rafalib::mypar(3,4)
for(i in 1:12){
  image(matrix(x_test[i,], 28, 28)[, 28:1], 
        main = paste("Our prediction:", y_hat_rf[i]),
        xaxt="n", yaxt="n")
}






###var importance
# the rborist package does not support varImp by randomforest does
library(randomForest)
x <- mnist$train$images[index,]
y <- factor(mnist$train$labels[index])
rf <- randomForest(x, y,  ntree = 50)
imp <- importance(rf)
imp

image(matrix(imp, 28, 28))

#ordering the one with the highest probability that we called wrong for knn
p_max <- predict(fit_knn, x_test[,col_index])
p_max <- apply(p_max, 1, max)
ind  <- which(y_hat_knn != y_test)
ind <- ind[order(p_max[ind], decreasing = TRUE)]
rafalib::mypar(3,4)
for(i in ind[1:12]){
  image(matrix(x_test[i,], 28, 28)[, 28:1],
        main = paste0("Pr(",y_hat_knn[i],")=",round(p_max[i], 2),
                      " but is a ",y_test[i]),
        xaxt="n", yaxt="n")
}
#ordering the one with the highest probability that we called wrong for rf
p_max <- predict(fit_rf, x_test[,col_index])$census  
p_max <- p_max / rowSums(p_max)
p_max <- apply(p_max, 1, max)
ind  <- which(y_hat_rf != y_test)
ind <- ind[order(p_max[ind], decreasing = TRUE)]
rafalib::mypar(3,4)
for(i in ind[1:12]){
  image(matrix(x_test[i,], 28, 28)[, 28:1], 
        main = paste0("Pr(",y_hat_rf[i],")=",round(p_max[i], 2),
                      " but is a ",y_test[i]),
        xaxt="n", yaxt="n")
}


####ensembles
#### combining multiple fits to improve the overall accuracy
#here we averaged knn and rf probabilities
p_rf <- predict(fit_rf, x_test[,col_index])$census
p_rf <- p_rf / rowSums(p_rf)
p_knn <- predict(fit_knn, x_test[,col_index])
p <- (p_rf + p_knn)/2
y_pred <- factor(apply(p, 1, which.max)-1)
confusionMatrix(y_pred, y_test)