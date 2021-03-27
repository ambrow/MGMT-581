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
# When you hear these questions, what immediately comes to your mind?
  
#  Linear Regression: can we accurately use predictor variables to predict loan amount?
#  Tree based models: are there non-linear corner cases in the data that are easy to identify via decision tree based models?
#  Clustering: are there specific groups within the data that have different characteristics and as a result have different delay times?

# Data Exploration
#####

# What should we check when we get a dataset?
flights_df %>%
  glimpse()

flights_df %>%
  purrr::map(typeof)

flights_df %>%
  group_by(ORIGIN_AIRPORT, DESTINATION_AIRPORT) %>%
  count()

flights_df %>%
  group_by(ORIGIN_AIRPORT, DESTINATION_AIRPORT, MONTH) %>%
  count()

flights_df %>%
  purrr::map(~ sum(is.na(.))) %>%
  rbind()

# flights_df %>%
#   sample_n(10000) %>%
#   ggplot(aes(x=SCHEDULED_DEPARTURE, y=SCHEDULED_ARRIVAL)) +
#   geom_point()

# flights_df %>%
#   group_by(DAY_OF_WEEK) %>%
#   sample_n(1000) %>%
#   ungroup() %>%
#   ggplot(aes(x=SCHEDULED_DEPARTURE, y=SCHEDULED_ARRIVAL)) +
#   facet_wrap(~DAY_OF_WEEK, ncol=7)

flights_df %>%
  group_by(CANCELLED) %>%
  count()

flights_df %>%
  group_by(MONTH, DAY_OF_WEEK, CANCELLED) %>%
  count() %>%
  pivot_wider(id_cols = c(MONTH, CANCELLED), names_from = DAY_OF_WEEK, values_from=n)

# flights_df %>%
#   group_by(MONTH, DAY_OF_WEEK, CANCELLED) %>%
#   count() %>%
#   ggplot(aes(x=n, color=as.factor(CANCELLED))) +
#   geom_bar() +
#   facet_wrap(MONTH~DAY_OF_WEEK, ncol=7)

flights_df %>%
  group_by(DIVERTED) %>%
  count()

flights_df %>%
  group_by(MONTH, DAY_OF_WEEK, DIVERTED) %>%
  count() %>%
  pivot_wider(id_cols = c(MONTH, DIVERTED), names_from = DAY_OF_WEEK, values_from=n)

# flights_df %>%
#   sample_n(10000) %>%
#   ggplot(aes(x=SCHEDULED_TIME, y=ELAPSED_TIME, color=DISTANCE)) +
#   geom_point()

flights_df %>%
  count(CANCELLATION_REASON)
