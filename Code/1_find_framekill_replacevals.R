# Replace the values with a list of vectors of move names that match the framekills
# Only returns frames with valid framekills
# Returns an empty list if no framekills were valid

find_framekill_replacevals <- function(framekill_list, moves_df) {

    new_framekill_list <- list()
    for (frames_to_kill in names(framekill_list)) {
        possible_movecombos <- list()

        # Make sure we're not touching 'no' values
        if (length(framekill_list[[frames_to_kill]]) == 1 & !is.matrix(framekill_list[[frames_to_kill]])) {
            if (!(framekill_list[[frames_to_kill]] == 'no')) {  # All 1-move framekills go here
                temp <- moves_df[moves_df$total_frames == as.integer(frames_to_kill), ]
                possible_movecombos <- temp$name
            }
        }

        if (length(framekill_list[[frames_to_kill]]) > 1 & !is.matrix(framekill_list[[frames_to_kill]])) {
            framekill_list[[frames_to_kill]] <- matrix(framekill_list[[frames_to_kill]], ncol = 1)
        }

        if (is.matrix(framekill_list[[frames_to_kill]])) {  # Most 2+ move framekills go here
            tempmat <- framekill_list[[frames_to_kill]]
            results <- NULL
            # For some reason, framekills with 2+ moves but only 1 combination of those 2 moves
            # makes 1 row of 2 values instead of 1 column with 2 vals. So we have to transpose here.
            if (nrow(tempmat) == 1) {
                tempmat <- t(tempmat)
            }
            for (coli in 1:ncol(tempmat)) {
                numvec <- tempmat[, coli]
                combo_temp <- list()
                # For each column, we make a list of possible moves for each number.
                # Then we combo those moves together in all possible ways
                for (framenumber in numvec) {
                    temp <- moves_df[moves_df$total_frames == as.integer(framenumber), ]
                    combo_temp[[as.character(framenumber)]] <- temp$name
                }
                if (is.null(results)) {
                    if (length(combo_temp) == 1) {
                        results <- as.data.frame(matrix(combo_temp[[names(combo_temp)[1]]], nrow = 1))
                    } else {
                        results <- as.data.frame(expand.grid(combo_temp))
                    }
                    colnames(results) <- paste0('move', 1:ncol(results))
                    results[] <- lapply(results, as.character)
                } else {
                    if (length(combo_temp) == 1) {
                        toadd <- as.data.frame(matrix(combo_temp[[names(combo_temp)[1]]], nrow = 1))
                    } else {
                        toadd <- as.data.frame(expand.grid(combo_temp))
                    }
                    colnames(toadd) <- colnames(results)
                    toadd[] <- lapply(toadd, as.character)
                    results <- rbind(results, toadd)
                }
            }
            possible_movecombos <- results

        }

        if (!identical(framekill_list[[frames_to_kill]], 'no')) {
            new_framekill_list[[frames_to_kill]] <- possible_movecombos
        }

    }

    return(new_framekill_list)

}
