# init.R
#
# Example R code to install packages if not already installed
#
a <- (.packages())  # Loaded packages

my_packages = a
install_if_missing = function(p) {
    if (p %in% rownames(installed.packages()) == FALSE) {
        install.packages(p)
    }
}
invisible(sapply(my_packages, install_if_missing))
