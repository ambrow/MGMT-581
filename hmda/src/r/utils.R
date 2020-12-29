
find_directory <- function(home_dir){
  dirs <- list.dirs(home_dir)
  dirs <- dirs[grepl("hdma", dirs)]
  dirs <- dirs[grepl("r$", dirs)]
  dirs[1]
}