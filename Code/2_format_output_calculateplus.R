format_output_calculateplus <- function(move_to_hit_input, plus_amount, moves_df) {


    # Find the ranges of frames that you want the move_to_hit to hit on.
    wanted_move <- moves_df[moves_df$input == move_to_hit_input, ]
    wanted_move <- wanted_move[1, ]
    wanted_move_frameranges <- wanted_move$preactive_frames + 1:wanted_move$total_active

    # Find advantage on block and hit for each active frame
    ob_frames <- wanted_move$advantage_onblock + 0:(length(wanted_move_frameranges)-1)
    oh_frames <- wanted_move$advantage_onhit + 0:(length(wanted_move_frameranges)-1)

    # Figure out the ranges of frames to kill
    framekill_frameranges <- plus_amount - wanted_move_frameranges + 1
    names(ob_frames) <- framekill_frameranges
    names(oh_frames) <- framekill_frameranges

    return(list('ob_frames' = ob_frames,
                'oh_frames' = oh_frames))

}
