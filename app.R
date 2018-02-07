
library(shiny)
library(shinydashboard)
library(shinyjs)

# Define ui section of app
ui <- dashboardPage(
  title = "Loading page for shiny dashboard",
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = dashboardBody(
    
    # Initiate shinyjs
    useShinyjs(),
    # Include custom js function for displaying header
    extendShinyjs(text = "shinyjs.hidehead = function(parm) {
                          $('header').css('display', parm);
                          }"),

    # Include css file in www/
    tags$head(tags$link(rel = "stylesheet",
                        type = "text/css",
                        href = "style.css")),
    
    # This div contains the loading page for the app
    div(
      class = "loading",
      h2("Loading"),
      div(
        class = "loader"
      ),
      id = "loading"
    ),
    
    # This is where our app content can be defined
    uiOutput("content")
  )
)

# Define server section of app
server <- function(input, output) {
  
  # We hide the sidebar with shinyjs::addClass
  addClass(selector = "body", class = "sidebar-collapse")
  # We hide the header with the custom javascript function
  # which is called using shinyjs::js
  js$hidehead("none")
  
  Sys.sleep(5)
  
  # To show main body
  removeClass(selector = "body", class = "sidebar-collapse")
  js$hidehead("")
  hide("loading")
  
  # Define ui body content
  output$content <- renderUI({
    tagList(
      textInput("txt", "Enter a title"),
      plotOutput("p")
    )
  })
  
  # Define p from the above expression
  output$p <- renderPlot({
    x <- rnorm(50)
    hist(x, main = input$txt)
  })
  
}

# Launch the app
shinyApp(ui = ui, server = server)