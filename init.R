# init.R
#
#
a <- c("ymlthis", "lubridate", "forcats", "stringr", "dplyr", "purrr", "readr", "tidyr", "tibble",
       "ggplot2", "tidyverse", "bslib", "shiny")

my_packages = a
install_if_missing = function(p) {
    if (p %in% rownames(installed.packages()) == FALSE) {
        install.packages(p)
    }
}
invisible(sapply(my_packages, install_if_missing))
