# Main function for retrieving framekills
source('Code/1_find_framekill_subfunction.R')
source('Code/1_find_framekill_replacevals.R')


find_framekill <- function(character_name, plus_amount,
                           move_to_hit_input, moves_df) {


    # Find the ranges of frames that you want the move_to_hit to hit on.
    wanted_move <- moves_df[moves_df$input == move_to_hit_input, ]
    wanted_move <- wanted_move[1, ]
    wanted_move_frameranges <- wanted_move$preactive_frames + 1:wanted_move$total_active

    # Figure out the ranges of frames to kill, plus one because the active frame needs to hit
    # the first frame AFTER they wake up, not the exact frame they end wakeup
    framekill_frameranges <- plus_amount - wanted_move_frameranges + 1


    ### The meat. Find the combination of moves that fills the framekill here
    framekill_list <- list()
    for (frames_to_kill in framekill_frameranges) {
        temp <- as.character(frames_to_kill)
        framekill_list[[temp]] <- find_framekill_subfunction(frames_to_kill, moves_df)
    }

    # You now have a list of frames to kill, and values of possible framekills
    # Replace the values with a list of vectors of move names that match the framekills
    # Leave the "no" values alone
    framekill_list <- find_framekill_replacevals(framekill_list, moves_df)

    return(framekill_list)
}
