create_output_string <- function(output_list) {

    output_string <- ''
    for (listname in names(output_list)) {

        oboh <- str_split(listname, '_')[[1]]
        ob <- str_split(oboh[1], 'ob')[[1]][2]
        oh <- str_split(oboh[2], 'oh')[[1]][2]
        obsymb <- ifelse(as.integer(ob) < 0, '-', '+')
        ohsymb <- ifelse(as.integer(oh) < 0, '-', '+')
        output_string <- paste0(output_string,
                                'To be ', obsymb, as.character(abs(as.integer(ob))),
                                ' on block or ', ohsymb, as.character(abs(as.integer(oh))), ' on hit:\n')
        movestrings <- str_split(output_list[[listname]], '\n')[[1]]
        i <- 1
        for (x in movestrings) {
            removed_underscores <- str_replace_all(x, '_', ' ')
            output_string <- paste0(output_string, '\t', i, ': ', removed_underscores, '\n')
            i <- i + 1
        }
        output_string <- paste0(output_string, '\n')

    }

    return(output_string)

}
