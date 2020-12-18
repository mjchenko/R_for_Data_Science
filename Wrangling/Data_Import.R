# see working directory
getwd()

# change your working directory
# setwd()

# set path to the location for raw data files in the dslabs package and list files
path <- system.file("extdata", package="dslabs")
list.files(path)

# generate a full path to a file
filename <- "murders.csv"
fullpath <- file.path(path, filename)
fullpath

# copy file from dslabs package to your working directory
file.copy(fullpath, getwd())

# check if the file exists
file.exists(filename)


#### readr and readxl
library(dslabs)
library(tidyverse)    # includes readr
library(readxl)

# inspect the first 3 lines
read_lines("murders.csv", n_max = 3)

# read file in CSV format
dat <- read_csv(filename)

#read using full path
dat <- read_csv(fullpath)
head(dat)

#Ex：
path <- system.file("extdata", package = "dslabs")
files <- list.files(path)
files

filename <- "murders.csv"
filename1 <- "life-expectancy-and-fertility-two-countries-example.csv"
filename2 <- "fertility-two-countries-example.csv"
dat=read.csv(file.path(path, filename))
dat1=read.csv(file.path(path, filename1))
dat2=read.csv(file.path(path, filename2))



#### R-base import functions (read.csv(), read.table(), read.delim()) generate 
# data frames rather than tibbles and character variables are converted to 
# factors. This can be avoided by setting the argument stringsAsFactors=FALSE.

# filename is defined in the previous video
# read.csv converts strings to factors
dat2 <- read.csv(filename)
class(dat2$abb)
class(dat2$region)




#### downloading files from the internet

# The read_csv() function and other import functions can read a URL directly.
# If you want to have a local copy of the file, you can use download.file().
# tempdir() creates a directory with a name that is very unlikely not to be unique.
# tempfile() creates a character string that is likely to be a unique filename.

url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"
dat <- read_csv(url)
download.file(url, "murders.csv")
tempfile()
tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename)



#ex
f <- "wdbc.data"
dat3 <- read_csv(f, col_names = FALSE)
nrow(dat3)
ncol(dat3)