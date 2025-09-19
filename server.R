library(shiny)
library(bslib)
library(dplyr)
library(stringr)

source('Code/0_filter_moves_df.R')
source('Code/1_find_framekill.R')
source('Code/2_format_output.R')
source('Code/3_create_output_string.R')

# Get the character dropdown list options
rds_to_load <- 'Data/rds_files/moves_df_sagatupdate.rds'

moves_df <- readRDS(rds_to_load)
characters <- unique(moves_df$character)
characters <- characters[!(characters == 'common')]
charlist <- list()
for (charname in characters) {
    if (charname == 'aki') {
        charlist[['A.K.I.']] <- 'aki'
    } else if (charname == 'deejay') {
        charlist[['Dee Jay']] <- 'deejay'
    } else if (charname == 'mbison') {
        charlist[['M. Bison']] <- 'mbison'
    } else {
        newname <- paste0(toupper(substring(charname, 1, 1)), substring(charname, 2, str_length(charname)))
        charlist[[newname]] <- charname
    }
}

# Define server logic ----
server <- function(input, output, session) {

    observe({
        invalidateLater(10000)
        cat(".")
    })

    # The character selection dropdown
    output$selectOut <- renderPrint({ input$character_selection })

    # The moves dropdown, which changes with the character selection dropdown
    # Whatever is inside `observeEvent()` will be triggered each time the first
    # argument undergoes a change in value.
    observeEvent(input$character_selection,
                 {
                     moves_df <- readRDS(rds_to_load)
                     new_moves_df <- filter_moves_df(input$character_selection, moves_df)
                     new_moves_inputs <- new_moves_df$input
                     new_moves_names <- new_moves_df$name
                     selectionlist <- list()
                     for (i in 1:length(new_moves_inputs)) {
                         inputstring <- new_moves_inputs[i]
                         namestring <- new_moves_names[i]
                         toshow <- paste0(inputstring, ' (', namestring, ')')
                         selectionlist[[toshow]] <- inputstring
                     }
                     updateSelectizeInput(session, inputId = "move_to_hit_selector",
                                          choices = selectionlist)
                 })

    # Get them to input how plus they are


    # Whenever a new move is selected, we recalculate the framekills and render the output
    # TODO: There should probably be a button here to update the result, so observe the button instead
    observeEvent(input$action,
                 {
                     moves_df <- readRDS(rds_to_load)
                     moves_df <- filter_moves_df(input$character_selection, moves_df)

                     framekill_list <- find_framekill(input$character_selection, input$plus_amount,
                                                      input$move_to_hit_selector, moves_df)

                     if (length(framekill_list) != 0) {
                         output_list <- format_output(input$character_selection, input$plus_amount,
                                                      input$move_to_hit_selector, moves_df, framekill_list)

                         text_to_render <- create_output_string(output_list)

                     } else {
                         text_to_render <- paste0('No framekills found for ',
                                                  input$character_selection, "'s ",
                                                  input$move_to_hit_selector,
                                                  ' when you are +', input$plus_amount)
                     }
                     output$output_framekill <- renderText({ text_to_render })
                 })

}
