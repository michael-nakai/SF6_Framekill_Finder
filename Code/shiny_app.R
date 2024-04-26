library(shiny)
library(bslib)
library(dplyr)
library(stringr)

source('Code/0_filter_moves_df.R')
source('Code/1_find_framekill.R')
source('Code/2_format_output.R')
source('Code/3_create_output_string.R')

# Get the character dropdown list options
moves_df <- readRDS('Data/rds_files/moves_df.rds')
characters <- unique(moves_df$character)
characters <- characters[!(characters == 'common')]
charlist <- list()
for (charname in characters) {
    if (charname == 'aki') {
        charlist[['A.K.I.']] <- 'aki'
    } else if (charname == 'deejay') {
        charlist[['Dee Jay']] <- 'deejay'
    } else {
        newname <- paste0(toupper(substring(charname, 1, 1)), substring(charname, 2, str_length(charname)))
        charlist[[newname]] <- charname
    }
}


# UI
ui <- fluidPage(

    tags$head(tags$style(HTML("
    .shiny-text-output {
      background-color:#fff;
    }
  "))),

  h1("Shiny", span("Widgets Gallery", style = "font-weight: 300"),
     style = "font-family: 'Source Sans Pro';
        color: #fff; text-align: center;
        background-image: url('texturebg.png');
        padding: 20px"),
  br(),

  fluidRow(
      column(6, offset = 3,
             p("SF6 framekill finder",
               style = "font-family: 'Source Sans Pro';
        text-align: center;
        font-size: 40px;")
      )
  ),


  br(),

  # Choose your character
  fluidRow(
      wellPanel(
          selectInput("character_selection", label = h3("1. Choose your character"),
                      choices = charlist, selected = 'zangief'),
          hr()
      )
  ),

  # Choose the move to hit meaty
  fluidRow(
      wellPanel(
          selectInput("move_to_hit_selector", label = h3("2. Select the meaty"),
                      choices = NULL, multiple = F),
          hr()
      )
  ),

  # Input your frame advantage in this situation
  fluidPage(
      wellPanel(
          numericInput("plus_amount", label = h3("3. How plus are you?"), value = 1),
          hr()
      )
  ),

  # Button to kick everything off
  fluidPage(
      wellPanel(
          actionButton("action", label = "4. Hit the button"),
          hr()
      )
  ),

  # Display output
  fluidRow(
      wellPanel(
          verbatimTextOutput("output_framekill"),
          hr()
      )
  )

)


# Define server logic ----
server <- function(input, output, session) {

    # The character selection dropdown
    output$selectOut <- renderPrint({ input$character_selection })

    # The moves dropdown, which changes with the character selection dropdown
    # Whatever is inside `observeEvent()` will be triggered each time the first
    # argument undergoes a change in value.
    observeEvent(input$character_selection,
                 {
                     moves_df <- readRDS('Data/rds_files/moves_df.rds')
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
                     moves_df <- readRDS('Data/rds_files/moves_df.rds')
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


shinyApp(ui = ui, server = server)
