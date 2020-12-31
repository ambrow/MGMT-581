# clean data
renv::restore()

library(dplyr)
clean_action_taken <- function(df){
    clean_df <- df
    clean_df <- clean_df %>%
      filter(action_taken %in% c(1,3)) %>%
      mutate(
        action_taken = as.factor(as.character(action_taken)),
        action_taken_clean = 
             forcats::fct_recode(action_taken,
                        "loan-approved"="1",
                        "loan-rejected"="3"))
    clean_df
}

clean_loan_type <- function(df){
  clean_df <- df
  clean_df <- clean_df %>%
    mutate(loan_type = as.factor(as.character(loan_type)),
           loan_type_clean = 
             forcats::fct_recode(loan_type,
               "Conventional"="1",
               "FHA"="2",
               "VA"="3",
               "USDA-or-RHA"="4"
             ))
  clean_df
  }

clean_loan_purpose <- function(df){
  clean_df <- df
  clean_df <- clean_df %>%
    mutate(loan_purpose = as.factor(as.character(loan_purpose)),
           loan_purpose_clean = 
             forcats::fct_recode(loan_purpose,
                "purchase"="1",
                "improvement"="2",
                "refinance"="31",
                "cash-out-refi"="32",
                "other"="4",
                "N/A"="5"))
  clean_df
}

clean_hoepa <- function(df){
  clean_df <- df
  clean_df <- clean_df %>%
    mutate(hoepa_status = as.factor(as.character(hoepa_status)),
           hoepa_status_clean = 
             forcats::fct_recode(hoepa_status,
                "high-cost"="1",
                "not-high-cost"="2",
                "N/A"="3"))
  clean_df
}

clean_occupancy <- function(df){
  clean_df <- df
  clean_df <- clean_df %>%
    mutate(occupancy_type = as.factor(as.character(occupancy_type)),
           occupancy_type_clean = 
             forcats::fct_recode(occupancy_type,
                "principal"="1",
                "second"="2",
                "investment"="3"))
  clean_df
}

# cleaned_df = hmda_data_raw %>%
#   clean_action_taken() %>%
#   clean_loan_type() %>%
#   clean_loan_purpose() %>%
#   clean_hoepa() %>%
#   clean_occupancy()
# 
# rm(hmda_data_raw, clean_action_taken, clean_loan_type, clean_loan_purpose, clean_hoepa, clean_occupancy)