library(RJSONIO)

# Run the app once, then:

a <- (.packages())  # Loaded packages
a <- a[a != 'base']
pkgs <- as.data.frame(installed.packages())  # Installed packages
pkgs <- pkgs %>% select(Package, Version)
rownames(pkgs) <- NULL

json_list <- vector(mode = 'list', length = length(a))
i <- 1
for (pname in a) {
    row <- match(pname, pkgs$Package)
    vectoadd <- c(pkgs$Package[row], pkgs$Version[row])
    names(vectoadd) <- c('package', 'version')
    json_list[[i]] <- vectoadd
    i <- i + 1
}

exportJson <- toJSON(json_list)
write(exportJson, 'packagelist.json')

# Manual curating of the list in the dockerfile needed after this
