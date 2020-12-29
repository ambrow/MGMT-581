# This script will initialize the environment we are running code in
# Run this script the first time you are accessing the repo
# SOURCE: https://environments.rstudio.com/snapshot.html

install.packages("remotes")
remotes::install_github("rstudio/renv")
source("utils.R")
proj_dir <- find_directory("~")
renv::init(proj_dir)