library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

# 3 significant digits
options(digits = 3)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

#Q1
y <- titanic_clean$Survived
set.seed(42, sample.kind = "Rounding")
test_ind <- createDataPartition(y, times = 1, p = 0.2, list = FALSE)
test_set <- titanic_clean %>% slice(test_ind)
train_set <- titanic_clean %>% slice(-test_ind)
mean(ifelse(train_set$Survived == 1, 1, 0))
#or
mean(train_set$Survived == 1)


#Q2
# predict with guessing
# Set the seed to 3. For each individual in the test set, randomly guess whether 
# that person survived or not by sampling from the vector c(0,1) 
# (Note: use the default argument setting of prob from the sample function).
set.seed(3, sample.kind = "Rounding")
pred_guess <- sample(c(0, 1), size = nrow(test_set), replace = TRUE) %>% as.factor()
confusionMatrix(test_set$Survived, pred_guess)

#Q3
# proportion of females and males survived
p_survive <- train_set %>% group_by(Sex) %>% summarize(p = mean(Survived == 1))
p_survive

#predict survival based on Sex in the test set
# if the survival rate for a sex is over 0.5, predict survival for all 
# individuals of that sex, and predict death if the survival rate for a sex is under 0.5.
y_hat_s <- ifelse(test_set$Sex == "female", 1, 0)
mean(y_hat == test_set$Survived)   

#Q4
#passenger class prob of surviving
p_survive_class <- train_set %>% group_by(Pclass) %>% summarize(p = mean(Survived == 1))

#use to predict if passenger class > 0.5
y_hat_c <- ifelse(test_set$Pclass == "1", 1, 0)
mean(y_hat == test_set$Survived)

train_set %>% group_by(Pclass, Sex) %>% summarize(p = mean(Survived == 1))

#use to predit if sex and class > 0.5
y_hat_s_c <- ifelse(test_set$Pclass %in% c(1,2) & test_set$Sex == "female", 1, 0)
mean(y_hat == test_set$Survived)

#Q5&6 for each different model
confusionMatrix(as.factor(y_hat_s), test_set$Survived)
confusionMatrix(as.factor(y_hat_c), test_set$Survived)
confusionMatrix(as.factor(y_hat_s_c), test_set$Survived)

F_meas(as.factor(y_hat_s), test_set$Survived)
F_meas(as.factor(y_hat_c), test_set$Survived)
F_meas(as.factor(y_hat_s_c), test_set$Survived)

#Q7
#use lda with fare as the only predictor
set.seed(1, sample.kind = "Rounding")
fit_lda <- train(Survived ~ Fare, data = train_set, method = "lda")
y_hat_lda <- predict(fit_lda, test_set)
mean(y_hat_lda == test_set$Survived)

#use qda with fare as only predictor
set.seed(1, sample.kind = "Rounding")
fit_qda <- train(Survived ~ Fare, data = train_set, method = "qda")
y_hat_qda <- predict(fit_qda, test_set)
mean(y_hat_qda == test_set$Survived)

#Q8
#train logistic regression model with age as the only predictor
set.seed(1, sample.kind = "Rounding")
fit_glm <- train(Survived ~ Age, data = train_set, method = "glm")
y_hat_glm <- predict(fit_glm, test_set)
mean(y_hat_glm == test_set$Survived)

#train logistic regression model with 4 predictors
set.seed(1, sample.kind = "Rounding")
fit_glm4 <- train(Survived ~ Age + Sex + Pclass + Fare, data = train_set, method = "glm")
y_hat_glm4 <- predict(fit_glm4, test_set)
mean(y_hat_glm4 == test_set$Survived)

#logistic regresssion with all predictors
set.seed(1, sample.kind = "Rounding")
fit_glm_all <- train(Survived ~ ., data = train_set, method = "glm")
y_hat_glm_all <- predict(fit_glm_all, test_set)
mean(y_hat_glm_all == test_set$Survived)

#Q9
#knn model 
set.seed(6, sample.kind = "Rounding")
grid = data.frame(k = seq(3, 51, 2))
fit_knn <- train(Survived ~ ., data = train_set, method = "knn", tuneGrid = grid)
plot(fit_knn)
#or
plot(fit_knn$results$k, fit_knn$results$Accuracy)

#accuracy on the test set
y_hat_knn <- predict(fit_knn, test_set)
mean(y_hat_knn == test_set$Survived)


#Q10
#knn with cross validation
set.seed(8, sample.kind = "Rounding")
grid = data.frame(k = seq(3, 51, 2))
fit_knn_cv <- train(Survived ~ ., data = train_set, method = "knn", tuneGrid = grid, trControl = trainControl(method = "cv", number = 10, p = 0.9))
fit_knn_cv$finalModel$k
y_hat_knn_cv <- predict(fit_knn_cv, test_set)
mean(y_hat_knn_cv == test_set$Survived)

#Q11
#rpart decision tree
set.seed(10, sample.kind = "Rounding")
grid = data.frame(cp = seq(0, 0.05, 0.002))
fit_rpart <- train(Survived ~ ., data = train_set, method = "rpart", tuneGrid = grid)
y_hat_rpart <- predict(fit_rpart, test_set)
mean(y_hat_rpart == test_set$Survived)

#Q11bc
#plotting decision tree
plot(fit_rpart$finalModel, margin = 0.1)
text(fit_rpart$finalModel, cex = 0.75)
#or
library(rattle)
fancyRpartPlot(fit_rpart$finalModel)

#branches on left are yes.  0 means died, 1 means survived

#Q12
#random forest
set.seed(14, sample.kind = "Rounding")
grid = data.frame(mtry = seq(1:7))
fit_rf <- train(Survived ~ ., data = train_set, method = "rf", tuneGrid = grid, ntree = 100)
fit_rf$results$mtry
y_hat_rf <- predict(fit_rf, test_set)
mean(y_hat_rf == test_set$Survived)
imp <- varImp(fit_rf)
imp

