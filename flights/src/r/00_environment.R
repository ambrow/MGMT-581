
build_env <- FALSE

if (build_env) {
  install.packages("tidyverse")
  install.packages("magrittr")
}
  
  
library(tidyverse)
library(magrittr)

data_path <- paste0(stringr::str_split(getwd(),"src")[[1]][1], "data/")

rm(build_env)