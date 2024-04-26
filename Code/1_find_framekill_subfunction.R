# Returns a matrix with possible framekill combinations in the columns
# Returns 'no' if no framekills are available
find_framekill_subfunction <- function(frames_to_kill, moves_df) {

    # Figure out up to how many moves the character could possibly do in the framekill
    fastest_move <- min(moves_df$total_frames[!is.na(moves_df$total_frames)])
    number_of_moves_max <- floor(as.integer(frames_to_kill) / fastest_move)

    # Make some useful vectors
    totalframe_vec <- sort(unique(moves_df$total_frames[!is.na(moves_df$total_frames)]))

    # Try out different numbers of moves to fill the framekill. Start with 1
    if (number_of_moves_max >= 1) {
        for (number_of_moves in 1:number_of_moves_max) {

            # First see if any number of moves actually sum up to the framekill
            # Returns a vector if there's one possibility, a matrix if >1, and an empty matrix if no possibilities
            # Each combination is a column
            allcomb <- combn(rep(totalframe_vec, number_of_moves), number_of_moves)
            possibles <- allcomb[, colSums(allcomb) == frames_to_kill]

            if (is.matrix(possibles)) {  # If there's 1 possibility for 1 move, then it's just an int vector
                if (ncol(possibles) >= 2) {  # If there's more than 1 possible framekill combination
                    possibles <- possibles[, !duplicated(t(possibles))]  # Remove duplicate cols
                    temp <- t(apply(possibles, 2, sort))
                    possibles <- t(temp[duplicated(temp), ])
                }
            }

            if (length(possibles) == 0) {
                possibles <- NULL
            }

            # If we found a possible framekill, break the loop.
            # This always breaks with the minimum amount of moves
            if (!is.null(possibles)) {
                break
            }

            # This only happens if the loop continues, aka if no framekills are found
            possibles <- 'no'
        }
    } else {  # If the number of available frames are less than the total frametime of the fastest move
        possibles <- 'no'
    }

    return(possibles)

}
