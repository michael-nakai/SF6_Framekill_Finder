library(dplyr)
# Retrieves framedata for all moves in SF6 and populates a dataframe
# Manually rerun every update


# Download files
git2r::clone('https://github.com/4rays/sf6-move-data',
             local_path = 'C:\\Users\\Michael\\Desktop\\Code\\R\\SF6_tech\\Data\\data_git_sagatupdate')

datapath <- 'Data\\data_git_sagatupdate\\moves\\'

# Read in the movelists per character and assign to elements in list
toml_list <- list()
for (filename in dir(datapath)) {
    charactername <- strsplit(filename, '.', fixed = T)[[1]][1]
    toml_list[[charactername]] <- ymlthis::read_toml(paste0(datapath, filename))
}


# Make the columns for the dataframe and create dimensions as required
total_moves <- 0
for (charactername in names(toml_list)) {
    total_moves <- total_moves + length(toml_list[[charactername]]$moves)
}
columns_to_make <- c('character',
                     'abbreviation',
                     'name',
                     'alternativeNames',
                     'input',
                     'startup',
                     'preactive_frames',
                     'active_start',
                     'active_end',
                     'total_active',
                     'recovery_frames',
                     'recovery_frames_postlanding',
                     'total_frames',
                     'blockType',
                     'damage',
                     'scaling',
                     'drive_onblock',
                     'drive_onhit',
                     'drive_onpunishcounter',
                     'advantage_onblock',
                     'advantage_onhit',
                     'hitcount',
                     'slug',
                     'super_gain',
                     'type')
moves_df <- as.data.frame(matrix(NA, nrow = total_moves, ncol = length(columns_to_make)))
colnames(moves_df) <- columns_to_make

# Start populating the dataframe
rownum <- 1
for (charactername in names(toml_list)) {

    for (move1 in toml_list[[charactername]]$moves) {

        moves_df$character[rownum] <- charactername
        moves_df$name[rownum] <- move1$name
        moves_df$input[rownum] <- move1$input
        moves_df$slug[rownum] <- move1$slug
        moves_df$type[rownum] <- move1$type

        # Some moves don't have a scaling parameter
        if ('scaling' %in% names(move1)) {
            moves_df$scaling[rownum] <- paste(move1$scaling, collapse = '_')
        }

        # Some don't have abbreviations or alternate names either
        if ('abbreviation' %in% names(move1)) {
            moves_df$abbreviation[rownum] <- move1$abbreviation
        }
        if ('alternativeNames' %in% names(move1)) {
            moves_df$alternativeNames[rownum] <- paste(move1$alternativeNames, collapse = '_')
        }


        # AKI's puddle doesn't have a block, damage, hitCount, superArt, or drive parameter
        # Also, OD buttons tend to not have drive gauge recovery on hit
        if ('blockType' %in% names(move1)) {
            moves_df$blockType[rownum] <- move1$blockType
        }
        if ('damage' %in% names(move1)) {
            moves_df$damage[rownum] <- move1$damage
        }
        if ('driveGauge' %in% names(move1)) {
            if ('onHit' %in% names(move1$driveGauge)) {
                moves_df$drive_onhit[rownum] <- move1$driveGauge$onHit
            }
            if ('onBlock' %in% names(move1$driveGauge)) {
                moves_df$drive_onblock[rownum] <- move1$driveGauge$onBlock
            }
            if ('onPunishCounter' %in% names(move1$driveGauge)) {
                moves_df$drive_onpunishcounter[rownum] <- move1$driveGauge$onPunishCounter
            }
        }
        if ('hitCount' %in% names(move1)) {
            moves_df$hitcount[rownum] <- move1$hitCount
        }
        if ('superArt' %in% names(move1)) {
            moves_df$super_gain[rownum] <- move1$superArt
        }
        if ('startup' %in% names(move1)) {
            moves_df$startup[rownum] <- move1$startup
        }

        # Jumping buttons have a post-landing recovery frames parameter instead of recovery frames
        # They also don't have frameAdvantage parameters since it depends on how low you hit
        if ('postLandingRecovery' %in% names(move1)) {  # This is for air buttons only
            moves_df$recovery_frames_postlanding[rownum] <- move1$postLandingRecovery

        } else {  # This is for ground buttons only

            # AKI's cr.HP also doesn't have an on-hit advantage parameter
            # AKI's lv2 super's last hit has its own move for some reason
            if ('frameAdvantage' %in% names(move1)) {
                if ('hit' %in% names(move1$frameAdvantage)) {
                    moves_df$advantage_onhit[rownum] <- move1$frameAdvantage$hit
                }

                if ('block' %in% names(move1$frameAdvantage)) {
                    moves_df$advantage_onblock[rownum] <- move1$frameAdvantage$block
                }
            }

            # AKI...
            if ('active' %in% names(move1)) {
                moves_df$active_start[rownum] <- move1$active[1]
                moves_df$active_end[rownum] <- move1$active[2]
                moves_df$total_active[rownum] <- move1$active[2] - move1$active[1] + 1
            }

            # ffs AKI
            if ('recovery' %in% names(move1)) {
                moves_df$recovery_frames[rownum] <- move1$recovery
            }
        }

        rownum <- rownum + 1

    }
}


# Add character-specific dashes into df
# Read in the movelists per character and assign to elements in list
dashframes <- ymlthis::read_toml('Data\\MyData\\dashframes.toml')
dash_df <- as.data.frame(matrix(NA, ncol = ncol(moves_df), nrow = length(names(dashframes))*2))
colnames(dash_df) <- colnames(moves_df)
i <- 1
for (charactername in names(dashframes)) {
    for (movename in names(dashframes[[charactername]][[1]])) {

        dash_df$character[i] <- charactername

        if (movename == 'dash_b') {  # backdashes
            dash_df$abbreviation[i] <- '44'
            dash_df$name[i] <- 'Backwards Dash'
            dash_df$alternativeNames[i] <- 'Backdash'
            dash_df$input[i] <- '44'
            dash_df$type[i] <- 'movement'
            dash_df$total_frames[i] <- dashframes[[charactername]][[1]][['dash_b']]
        } else if (movename == 'dash_f') {  # forward dashes
            dash_df$abbreviation[i] <- '66'
            dash_df$name[i] <- 'Forward Dash'
            dash_df$alternativeNames[i] <- 'Dash'
            dash_df$input[i] <- '66'
            dash_df$type[i] <- 'movement'
            dash_df$total_frames[i] <- dashframes[[charactername]][[1]][['dash_f']]
        }

        i <- i + 1
    }
}


# Calculate total frames for all moves
moves_df$preactive_frames <- moves_df$startup - 1
moves_df$total_frames <- moves_df$preactive_frames + moves_df$total_active + moves_df$recovery_frames

moves_df <- rbind(moves_df, dash_df)




saveRDS(moves_df, 'Data\\rds_files\\moves_df_sagatupdate.rds')




