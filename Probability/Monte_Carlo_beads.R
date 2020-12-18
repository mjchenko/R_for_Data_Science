beads <- rep(c("red", "blue"), times = c(2,3))    # create an urn with 2 red, 3 blue
beads    # view beads object
sample(beads, 1)    # sample 1 bead at random

B <- 10000    # number of times to draw 1 bead
events <- replicate(B, sample(beads, 1))    # draw 1 bead, B times
tab <- table(events)    # make a table of outcome counts
tab    # view count table
prop.table(tab)    # view table of outcome proportions

# or 
events <- sample(beads, B, replace = TRUE)
tab <- table(events)    # make a table of outcome counts
tab    # view count table
prop.table(tab)    # view table of outcome proportions


# set.seed(1)
# set.seed(1, sample.kind="Rounding")    # will make R 3.6 generate a seed as in R 3.5

#using mean for probability
beads <- rep(c("red", "blue"), times = c(2,3))
beads
mean(beads == "blue")