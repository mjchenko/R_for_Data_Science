library(matrixStats)

sds <- colSds(x)
qplot(sds, bins = "30", color = I("black"))
image(1:28, 1:28, matrix(sds, 28, 28)[, 28:1])

#extract columns and rows
x[ ,c(351,352)]
x[c(2,3),]
new_x <- x[ ,colSds(x) > 60]
dim(new_x)
#if you select one row or column they are no longer matrices because they are vectors
class(x[,1])
dim(x[1,])


# we can preserve the matrix class using drop = FALSE
class(x[ , 1, drop=FALSE])
dim(x[, 1, drop=FALSE])