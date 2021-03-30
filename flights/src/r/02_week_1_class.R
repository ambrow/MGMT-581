# Week 1 Class

# Here we will walk through some code to answer the questions we talk about in class

# Imports
#####
source("00_environment.R")

# Flights
#####
flights_df <- readr::read_csv(paste0(data_path, "flights.csv"))
flights_df %>%
  head(10)

# The Business Problem
#####
# Delayed flights are an absolutely miserable customer experience. As a customer, I'm curious to avoid flights that are likely to be delayed when making purchasing decisions. We can use this data to build a model that helps me feel confident in those decisions (and that my flight won't be delayed!)

# There are two approaches we will follow in this course:
  
#  Can we predict how delayed a flight will be (continuous target variable)
#  Can we predict whether or not a flight will be delayed by 30 minutes or more? (binary target)

# Translating this problem into something we can solve Analytically
# Below are 3 analyses that come to my mind as a data scientist when I hear questions like the ones above. 

#  Linear Regression: can we accurately use predictor variables to predict loan amount?
#  Tree based models: are there non-linear corner cases in the data that are easy to identify via decision tree based models?
#  Clustering: are there specific groups within the data that have different characteristics and as a result have different delay times?

# Are there other analyses you might do that don't require data science or statistical techniques?

# Data Exploration
#####

# What checks do you perform when you get a dataset?

# What are the columns and their data types
flights_df %>%
  glimpse()

flights_df %>%
  purrr::map(typeof)

# What are the primary keys? How many things are there within specific groups?
flights_df %>%
  group_by(ORIGIN_AIRPORT, DESTINATION_AIRPORT) %>%
  count()

flights_df %>%
  group_by(ORIGIN_AIRPORT, DESTINATION_AIRPORT, MONTH) %>%
  count()


# Do we have missing values?
flights_df %>%
  purrr::map(~ sum(is.na(.))) %>%
  rbind()

# Do we see anything interesting visually?
# NOTE: I had to manually change data types here. R and Python read things differently!
flights_df %>%
  mutate(SCHEDULED_DEPARTURE = as.integer(SCHEDULED_DEPARTURE),
         SCHEDULED_ARRIVAL = as.integer(SCHEDULED_ARRIVAL)) %>%
  ggplot(aes(x=SCHEDULED_DEPARTURE, y=SCHEDULED_ARRIVAL)) +
  geom_bin2d(bins=20)

flights_df %>%
  mutate(SCHEDULED_DEPARTURE = as.integer(SCHEDULED_DEPARTURE),
         SCHEDULED_ARRIVAL = as.integer(SCHEDULED_ARRIVAL)) %>%
  ggplot(aes(x=SCHEDULED_DEPARTURE, y=SCHEDULED_ARRIVAL)) +
  geom_bin2d(bins=20) +
  facet_wrap(~DAY_OF_WEEK, ncol=1)

# What interesting columns can we use to build descriptives
flights_df %>%
  group_by(CANCELLED) %>%
  count()

flights_df %>%
  group_by(MONTH, DAY_OF_WEEK, CANCELLED) %>%
  count() %>%
  pivot_wider(id_cols = c(MONTH, CANCELLED), names_from = DAY_OF_WEEK, values_from=n)

flights_df %>%
  group_by(MONTH, DAY_OF_WEEK, CANCELLED) %>%
  count() %>%
  ggplot(aes(x=MONTH,y=n, fill=as.factor(CANCELLED))) +
  geom_col() +
  facet_wrap(~DAY_OF_WEEK, ncol=1)

flights_df %>%
  group_by(DIVERTED) %>%
  count()

flights_df %>%
  group_by(MONTH, DAY_OF_WEEK, DIVERTED) %>%
  count() %>%
  pivot_wider(id_cols = c(MONTH, DIVERTED), names_from = DAY_OF_WEEK, values_from=n)

# Are there inbuilt relationships within the data that we care about?

# Compare the speeds of these two
# R is much slower than Python, especially with the large data we have
# but there are still ways to speed up R code to get a similar result!

# The slow one that might break your R session
# flights_df %>%
#   mutate(SCHEDULED_TIME = as.integer(SCHEDULED_TIME),
#          ELAPSED_TIME = as.integer(ELAPSED_TIME)) %>%  
#   ggplot(aes(x=SCHEDULED_TIME, y=ELAPSED_TIME, color=DISTANCE)) +
#   geom_point()

# The faster slightly simpler chart
flights_df %>%
  mutate(SCHEDULED_TIME = as.integer(SCHEDULED_TIME),
         ELAPSED_TIME = as.integer(ELAPSED_TIME)) %>%  
  ggplot(aes(x=SCHEDULED_TIME, y=ELAPSED_TIME)) +
  geom_bin2d(bins=20)


# Data types once again make a check a bit harder to read than python
as.integer(flights_df$DEPARTURE_TIME) + as.integer(flights_df$TAXI_OUT) == as.integer(flights_df$WHEELS_OFF)

# this check is harder to perform in R
# what we see is that the clock is on a 24 hour time scale, so we can't just transform with as.integer. We need to be clear what we are adding!
flights_df %>%
  mutate(DEP_TIME = as.integer(DEPARTURE_TIME),
         TO = as.integer(TAXI_OUT),
         WHO = as.integer(WHEELS_OFF),
         check = DEP_TIME + TO == WHO) %>%
  group_by(check) %>%
  count()
  
# helpful category values - we will come back to this & more next week!
flights_df %>%
  count(CANCELLATION_REASON)
