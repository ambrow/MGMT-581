
renv::restore()
install.packages("remotes")
remotes::install_cran("ggplot2", dependencies = TRUE)
remotes::install_cran("readr", dependencies = TRUE)
remotes::install_cran("dplyr", dependencies = TRUE)
remotes::install_cran("data.table", dependencies = TRUE)
remotes::install_cran("curl", dependencies = TRUE)
remotes::install_cran("Rcpp", dependencies = TRUE)
remotes::install_cran("forcats", dependencies = TRUE)

renv::snapshot()