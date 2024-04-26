filter_moves_df <- function(character_name, moves_df) {

    moves_df <- moves_df[moves_df$character == character_name &
                             moves_df$type != 'followUp' &
                             moves_df$type != 'targetCombo' &
                             moves_df$type != 'super1' &
                             moves_df$type != 'super2' &
                             moves_df$type != 'super3' &
                             !is.na(moves_df$total_frames), ]

    # Also remove all rapid cancel moves
    moves_df <- moves_df[!grepl('Rapid Cancel', moves_df$name), ]

    return(moves_df)
}
