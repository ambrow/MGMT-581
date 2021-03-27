
# INTRO

# The goal of this script is to walk through the basics of our dataset for class code. 
# I've pulled the data from KAGGLE, and you can find more about it here https://www.kaggle.com/usdot/flight-delays

# Imports
#####
source("00_environment.R")

# Load the data

# Airlines
#####
airlines_df <- readr::read_csv(paste0(data_path,"airlines.csv"))

airlines_df %>%
  head(10)

airlines_df %>%
  glimpse()

# Airports
#####
airports_df <- readr::read_csv(paste0(data_path, "airports.csv"))

airports_df %>%
  head(10)

airports_df %>%
  glimpse()

airports_df %>%
  ggplot(aes(x=LATITUDE, y=LONGITUDE)) +
  geom_point()

airports_df %>%
  filter(LONGITUDE < -140)

# Flights
#####
flights_df <- readr::read_csv(paste0(data_path, "flights.csv"))
flights_df %>%
  head(10)

flights_df %>%
  glimpse()

flights_df %>%
  group_by(ORIGIN_AIRPORT) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(25)

flights_df %>%
  count(AIRLINE)
