# load data
renv::restore()


url_load <- function(states, year){
  state_string <- paste(states, collapse = ",")
  url = paste0("https://ffiec.cfpb.gov/v2/data-browser-api/view/csv?states=",state_string, "&years=",year)
  data.table::fread(url)
}

load_hmda <- function(states, years){
  dfs = lapply(years, url_load, states=states)
  data.table::rbindlist(dfs)
}

hmda_data_raw <- load_hmda(c("DC","MD"), c("2018", "2019"))

library(dplyr)
top_5_list <- hmda_data_raw %>%
  count(lei) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  top_n(5) %>%
  select(lei)

hmda_data_raw %>%
  filter(lei %in% top_5_list$lei)

hmda_data_raw %>%
  filter(action_taken %in% c(1,3)) %>%
  count()

library(ggplot2)

filtered <- hmda_data_raw %>%
  filter(action_taken %in% c(1,3)) %>%
  filter(loan_purpose==1) %>%
  filter(loan_amount <= 1000000)

means <- filtered %>%
  group_by(derived_race) %>%
  summarize(income = mean(income, na.rm=TRUE) * 1000)

filtered %>%
  ggplot(aes(x=derived_race, y=loan_amount, fill=as.factor(action_taken))) +
  geom_violin() +
  geom_bar(data = means, stat="identity", aes(x=derived_race, y = loan_amount, fill=NULL, alpha=.3)) + 
  coord_flip()

means %>%
  ggplot(aes()) +
  geom_bar(stat="identity", aes(x=derived_race, y=income, alpha=.3)) +
  geom_violin(data=filtered, aes(x=derived_race, y=loan_amount, fill=as.factor(action_taken)))+
  coord_flip()

filtered %>%
  select(income) %>%
  is.na() %>%
  sum() / nrow(filtered)

filtered %>%
  group_by(derived_race) %>%
  summarize(income=mean(income,na.rm = TRUE))