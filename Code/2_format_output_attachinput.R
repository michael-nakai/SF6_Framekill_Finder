getinput <- function(move, moves_df) {
    toreturn <- rep(NA, length(move))
    for (i in 1:length(move)) {
        toreturn[i] <- toupper(moves_df$input[moves_df$name == move[i]])
    }
    return(toreturn)
}
