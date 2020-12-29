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
