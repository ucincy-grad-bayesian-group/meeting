library(shiny)
library(bslib)
library(readxl)
library(writexl)

# Define UI ----
ui <- page_sidebar(
  title = "Patient Risk Prediction",
  sidebar = sidebar(
    card(
      card_header("Instruction"),
      helpText(
        "Ensure the data is formatted as follows: patient_id, diabetes, hypertension",
      )
    ),
    card(
    card_header("File input"),
    fileInput("file", label = NULL,accept = c(".xlsx")),
    downloadButton("downloadData", "Download")
  )
 ),
 tableOutput("table")
)
# Define server logic ----
server <- function(input, output) {
  
  # Reactive to process uploaded file
  data <- reactive({
    req(input$file) # Ensure a file is uploaded
    file <- input$file$datapath
    df <- read_excel(file) # Read the Excel file
    df$predicted_probability <- 0.5 # Add the predicted probability column
    return(df)
  })
  
  output$table <- renderTable({
    data()
  })
  
  # Handle file download
  output$downloadData <- downloadHandler(
    filename = function() {
      "predicted_data.xlsx"
    },
    content = function(file) {
      write_xlsx(data(), file) # Write the updated data to an Excel file
    }
  )
  
}

# Run the app ----
shinyApp(ui = ui, server = server)