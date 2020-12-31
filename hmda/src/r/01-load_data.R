# load data
renv::restore()


load_helper <- function(states, year){
  state_string <- paste(states, collapse = ",")
  url = paste0("https://ffiec.cfpb.gov/v2/data-browser-api/view/csv?states=",state_string, "&years=",year)
  data.table::fread(url)
}

load_hmda <- function(states, years){
  dfs = lapply(years, load_helper, states=states)
  data.table::rbindlist(dfs)
}

states <- c("DC", "VA")
years <- c("2018", "2019")

hmda_data_raw <- load_hmda(states, years)

rm(load_helper, load_hmda)
