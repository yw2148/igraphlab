library(shiny)
library(RMySQL)
library(flexdashboard)
library(tidyverse)
library(plotly)
library(shinyWidgets)
library(jsonlite)
library(DT)


ui <- fluidPage(

    titlePanel("Please Input: "),

    sidebarLayout(
        sidebarPanel(
          
          textInput("text", label = h3("Text input"), value = "SELECT * from PATIENTS;"),
          
          hr(),
          fluidRow(column(3, verbatimTextOutput("value"))),
          
          submitButton("QUERY")
          
          ),

        mainPanel(
          dataTableOutput("myTable")
        )
    )
)


server <- function(input, output, session) {
  
  connection <- dbConnect(
    MySQL(), 
    user = "mimicuser", 
    password = "mimiciii", 
    host = "localhost", 
    dbname = "mimiciiiv14")
  
  query_res <- reactive({dbGetQuery(connection, input[["text"]])})

  
  output$myTable <-renderDataTable(
    datatable(query_res(),
              options = list(
                scrollX = TRUE,
                scrollY = "500px"
              ),
              selection = "single")
  )

  onStop(function() {
    dbDisconnect(connection)  # Close MySQL connection
  })
}


shinyApp(ui = ui, server = server)

