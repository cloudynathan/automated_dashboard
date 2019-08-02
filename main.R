#load packages
suppressWarnings(suppressMessages(library(RMySQL)))
suppressWarnings(suppressMessages(library(shinydashboard)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(ggplot2)))

library(shiny)
library(DBI)
library(pool)

pool <- dbPool(drv = RMySQL::MySQL(),
               dbname = "studentperformance",
               host = "localhost",
               username = "root",
               password = "newrootpassword")

ui <- dashboardPage(
  dashboardHeader(title = "Student Performance"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Demographics", tabName = "demographics", icon = icon("id-card")),
      menuItem("Programs", tabName = "programs", icon = icon("folder")))),
  
  dashboardBody(
    tabItems(
      # Demographic tab content
      tabItem(tabName = "demographics",
              fluidRow(box(title = "GENDER", collapsible = TRUE, plotOutput("p1")),
                       box(title = "RACE_ETHNICITY", collapsible = TRUE, plotOutput("p2")),
                       box(title = "PARENT_EDUCATION", collapsible = TRUE, plotOutput("p3"))
              )
      ),
      
      # Programs tab content
      tabItem(tabName = "programs",
              fluidRow(box(title = "LUNCH", collapsible = TRUE, plotOutput("p4")),
                       box(title = "PREP_COURSE", collapsible = TRUE, plotOutput("p5"))
              )
      )
    )
  )
)


server <- function(input, output, session){
  getGender <- function(x){
    dbGetQuery(x, "SELECT gender, 'math' AS 'subject', AVG(math) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender 
                  UNION SELECT gender, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender 
                  UNION SELECT gender, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender;")
  }
  

  refreshData <- reactive({
    invalidateLater(3600000, session) 
    getGender(pool)
  })
  output$p1 <- renderPlot({ggplot(getGender, aes(x = gender, y = avg_score))+
      geom_col(aes(fill = subject), width = 0.7)})
}

shinyApp(ui, server)

##ERRORS:
#Warning: Error in : You're passing a function as global data.
#Have you misspelled the `data` argument in `ggplot()`
#[No stack trace available]
#Warning in (function (e)  : You have a leaked pooled object.
            




