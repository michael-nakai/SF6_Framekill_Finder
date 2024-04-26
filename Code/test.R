source('Code\\0_filter_moves_df.R')
source('Code\\1_find_framekill.R')
source('Code\\2_format_output.R')

character_name = 'kimberly'
moves_df <- readRDS('Data\\rds_files\\moves_df.rds')
setup <- 'MPxxHP 236K~MK'
move_to_hit_input <- '2hp'
plus_amount <- 40

moves_df <- filter_moves_df(character_name, moves_df)
framekill_list <- find_framekill(character_name, plus_amount, move_to_hit_input, moves_df)
output_list <- format_output(character_name, plus_amount, move_to_hit_input, moves_df, framekill_list)



input <- list(character_selection = 'kimberly',
              plus_amount = 47,
              move_to_hit_selector = '2hp')
character_name = 'kimberly'
plus_amount = 47
move_to_hit_input = '2hp'
