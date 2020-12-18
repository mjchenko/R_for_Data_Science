number <- "Three"
suit <- "Hearts"

#paste will join to strings (or pairs of vectors) together
paste(number, suit)

#example of vectors
paste(letters[1:5], as.character(1:5))

# expand.grid gives all the combinations of two lists
expand.grid(pants = c("blue", "black"), shirt = c("white", "grey", "plaid"))

# lets generate a deck of cards
suits <- c("Hearts", "Spades", "Diamonds", "Clubs")
numbers <- c("Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
             "Ten", "Jack", "Queen", "King")
deck <- expand.grid(number = numbers, suit = suits)
deck <- paste(deck$number, deck$suit)

#check probability king in first card is 1/13
kings <- paste("King", suits)
mean(deck %in% kings)

# permutations function computes for any list of size n, all the different ways 
# you can select r items
library(gtools)
#all the ways we can select 2 numbers from a list of 5 numbers
# with permutations order matters, 3, 1 is different from 1,3 
permutations(5, 2)

# possible hands
hands <- permutations(52, 2, v = deck)
first_card <- hands[,1]
second_card <- hands[,2]

#R version of multiplication rule. 
# Pr(B | A) = Pr(A and B) / Pr(A)
sum(first_card %in% kings & second_card %in% kings) / sum(first_card %in% kings)
mean(first_card %in% kings & second_card %in% kings) / mean(first_card %in% kings)

#what if order doesnt matter
# note how combinations are different than permutation.  in combination order 
# doesnt matter
combinations(3,2)
permutations(3,2)

#compute probability of 21 in black jack
aces <- paste("Ace", suits)
facecard <- c("King", "Queen", "Jack", "Ten")
facecard <- expand.grid(number = facecard, suit = suits)
facecard <- paste(facecard$number, facecard$suit)

hands <- combinations(52, 2, v = deck)

#probability of getting 21  
mean(hands[,1] %in% aces & hands[,2] %in% facecard) # here we assume aces come first because of how combination makes its combinations

#to be safe consider both
mean((hands[,1] %in% aces & hands[,2] %in% facecard) | 
       (hands[,1] %in% facecard & hands[,2] %in% aces))

B <- 10000
results <- replicate(B, {hand <- sample(deck, 2)
                      (hands[,1] %in% aces & hands[,2] %in% facecard) |
                      (hands[,1] %in% facecard & hands[,2] %in% aces)
                      })
mean(results)