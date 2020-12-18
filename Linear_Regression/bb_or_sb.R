library(Lahman)
library(tidyverse)
library(dslabs)
ds_theme_set()

# look at data between 1961 and 2001. 
# League changed to 162 games in 1961
# looking at building a team in 2002

#view relationship between homeruns per game and runs per game in scatter plot
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR / G, R_per_game = R / G) %>%
  ggplot(aes(HR_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)

#view relationship between sb per game and runs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(SB_per_game = SB / G, R_per_game = R / G) %>%
  ggplot(aes(SB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)

# relationship between bb per game and runs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_per_game = BB / G, R_per_game = R / G) %>%
  ggplot(aes(BB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)

#relationship between ab per game and runs per game
Teams %>% filter(yearID %in% 1961:2001 ) %>%
  mutate(AB_per_game = AB/G, R_per_game = R/G) %>%
  ggplot(aes(AB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)

#relationship between win rate vs number of errors per game
Teams %>% filter(yearID %in% 1961:2001 ) %>%
  mutate(E_per_game = E/G, W_rate = W/(W+L)) %>%
  ggplot(aes(W_rate, E_per_game)) + 
  geom_point(alpha = 0.5)

#relationship between triples/g and doubles/g
Teams %>% filter(yearID %in% 1961:2001 ) %>%
  mutate(d_per_game = X2B/G, t_per_game = X3B/G) %>%
  ggplot(aes(d_per_game, t_per_game)) + 
  geom_point(alpha = 0.5)


