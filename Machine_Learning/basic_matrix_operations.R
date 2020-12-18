library(tidyverse)
library(dslabs)
if(!exists("mnist")) mnist <- read_mnist()

class(mnist$train$images)

x <- mnist$train$images[1:1000,] 
y <- mnist$train$labels[1:1000]

# length of first colum of X
length(x[,1])
#define two vectors
x_1 <- 1:5
x_2 <- 6:10
#bind them into a matrix
cbind(x_1, x_2)
#get dimensions of x
dim(x)
#vectors dont have dimensions in R so it returns NULL
dim(x_1)
#if we convert the vext to matrix
dim(as.matrix(x_1))