
library(shiny)
library(RMySQL)
library(flexdashboard)
library(tidyverse)
library(plotly)
library(shinyWidgets)
library(jsonlite)
library(DT)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  titlePanel("Please Select Table Name"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "table_name",
        label = "Select Table",
        choices = NULL
      ),
      submitButton("SHOW")
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
  tables <- dbListTables(conn = connection, value = as.data.frame(tables))
  
  options_list <- reactive({
    tables
  })
  
  observe({
    updateSelectInput(session, "table_name", choices = options_list())
  })
  
  select_a_table = reactive({
    select_table = dbReadTable(conn = connection, 
                               name = input$table_name, 
                               value = as.data.frame(select_table))
  })
  
  output$myTable <-renderDataTable(
    datatable(select_a_table(),
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

