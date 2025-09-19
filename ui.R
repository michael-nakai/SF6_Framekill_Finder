library(shiny)
library(bslib)
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
    }else {
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
                      choices = charlist, selected = 'ryu'),
          hr()
      )
  ),

  # Choose the move to hit meaty
  fluidRow(
      wellPanel(
          selectInput("move_to_hit_selector", label = h3("2. Select the move that you want to hit meaty"),
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
