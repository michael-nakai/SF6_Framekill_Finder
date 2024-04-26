# init.R
#
#
a <- c("ymlthis", "stringr", "dplyr", "bslib", "shiny")

my_packages = a
install_if_missing = function(p) {
    if (p %in% rownames(installed.packages()) == FALSE) {
        install.packages(p)
    }
}
invisible(sapply(my_packages, install_if_missing))
