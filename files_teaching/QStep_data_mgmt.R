# Short session on data management using base R and tidyverse

# set session:
setwd("/Users/Lorenzo/Documents/Università/University_of_Essex/Teaching/GTA/QStep/2021:22/workshops/video1/rcode")
rm(list = ls())

library(tidyverse)

# first we import the data from the ANES
ANES <- read.csv("ANES.csv")
head(ANES)
# we have a long panel dataset: each state is observed at multiple points in time

# we can subset by rows (observations). For instance, maybe
# we want to keep only observations post-1990:
# using base R
my_new_data <- ANES[ANES$year > 1990,]

# or tidyverse
my_new_data <- ANES %>% filter(year > 1990)
head(my_new_data, n = 3)

# we can subset by columns (variables). For instance, maybe
# we want to keep only columns year, state, and white:
# using base R
my_new_data <- ANES[, c("year", "state", "white")]

# or tidyverse
my_new_data <- ANES %>% select("year", "state", "white")
head(my_new_data, n = 3)

# we can create new columns. For instance, maybe we want to 
# create a variable measuring the proportion of non-white voters:
# using base R
my_new_data$non_white <- 1- my_new_data$white

# or tidyverse
my_new_data <- my_new_data %>% mutate(non_white = 1-white)
head(my_new_data, n = 5)

# we can turn a long panel dataset into wide format. For instance,
# let's do that on a subset of ANES (only columns year, state, white):
# let's use tidyverse for this, simpler
ANES_wide <- ANES %>% 
  select("year", "state", "white") %>%
  pivot_wider(names_from = "year", values_from = "white")
head(ANES_wide[,1:10], n = 3)

# or we can turn a wide panel dataset into long format. Let's turn
# the wide dataset we have just created back into a long format:
# let's use tidyverse
ANES_long <- ANES_wide %>%
  pivot_longer(cols = !state, # all columns but the "state" one!
               names_to = "year",
               values_to = "white")
head(ANES_long, n = 3)

# we can also join different datasets with the same indicators.
# Let's import a new dataframe with additional ANES variables:
ANES_extra <- read.csv("ANES_extra.csv")
head(ANES_extra)

# we can merge them together using tidyverse:
merged <- ANES %>% left_join(ANES_extra, by = c("state", "year"))
head(merged)

### The End