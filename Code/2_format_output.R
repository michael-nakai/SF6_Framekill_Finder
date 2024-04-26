# Gets a final string to print
source('Code/2_format_output_calculateplus.R')
source('Code/2_format_output_attachinput.R')


format_output <- function(character_name, plus_amount, move_to_hit_input,
                          moves_df, framekill_list) {

    # Get frames on block and hit for the move
    hitblock_frames <- format_output_calculateplus(move_to_hit_input, plus_amount, moves_df)
    hitblock_frames$ob_frames <- rev(hitblock_frames$ob_frames)
    hitblock_frames$oh_frames <- rev(hitblock_frames$oh_frames)

    # Start with the MOST plus frame and work your way back
    stringlist <- list()

    for (listname in rev(names(framekill_list))) {

        moves_to_show <- framekill_list[[listname]]
        smallstring <- NULL

        if (is.data.frame(moves_to_show)) {  # At least 2 moves for the framekill
            for (i in 1:nrow(moves_to_show)) {
                temp <- as.character(unname(moves_to_show[i, ]))
                temp <- getinput(temp, moves_df)
                if (is.null(smallstring)) {
                    smallstring <- paste(temp, collapse = '_')
                } else {
                    smallstring <- paste0(smallstring, '\n',
                                          paste(temp, collapse = '_'))
                }


            }
        } else {  # 1 move for the framekill
            smallstring <- getinput(moves_to_show, moves_df)
        }

        newlistname <- paste0('ob', unname(hitblock_frames$ob_frames[listname]),
                              '_oh', unname(hitblock_frames$oh_frames[listname]))
        stringlist[[newlistname]] <- smallstring
    }

    return(stringlist)
}
