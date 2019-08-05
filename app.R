#load packages
suppressWarnings(suppressMessages(library(RMySQL)))
suppressWarnings(suppressMessages(library(shinydashboard)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(DBI)))
suppressWarnings(suppressMessages(library(pool)))
suppressWarnings(suppressMessages(library(rsconnect)))


pool <- dbPool(drv = RMySQL::MySQL(),
               dbname = "xxxxxxxxxx",
               host = "xxxxxxxxxx",
               username = "xxxxxxxxxx",
               password = "xxxxxxxxxx",
               port = xxxxxxxxxx)

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
    #plot1
    queryp1 <- "SELECT gender, 'math' AS 'subject', AVG(math) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender 
                  UNION SELECT gender, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender 
                  UNION SELECT gender, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
                  	FROM studentperformance
                  	GROUP BY gender;"
    p1 <- dbGetQuery(pool, queryp1)
    
    refreshData <- reactive({
        invalidateLater(1000, session) 
        p1(pool)
    })
    output$p1 <- renderPlot({
        invalidateLater(1000)
        ggplot(p1, aes(x = gender, y = avg_score))+
            geom_col(aes(fill = subject), width = 0.7)})
    
    #plot2
    queryp2 <- "SELECT race_ethnicity, 'math' AS 'subject', AVG(math) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY race_ethnicity 
              UNION SELECT race_ethnicity, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY race_ethnicity 
              UNION SELECT race_ethnicity, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY race_ethnicity;"
    p2 <- dbGetQuery(pool, queryp2)
    
    refreshData <- reactive({
        invalidateLater(1000, session) 
        p2(pool)
    })
    output$p2 <- renderPlot({
        invalidateLater(1000)
        ggplot(p2, aes(x = race_ethnicity, y = avg_score))+
            geom_col(aes(fill = subject), width = 0.7)})
    
    #plot3
    queryp3 <- "SELECT parent_education, 'math' AS 'subject', AVG(math) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY parent_education 
              UNION SELECT parent_education, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY parent_education 
              UNION SELECT parent_education, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY parent_education;"
    p3 <- dbGetQuery(pool, queryp3)
    
    refreshData <- reactive({
        invalidateLater(1000, session) 
        p3(pool)
    })
    output$p3 <- renderPlot({
        invalidateLater(1000)
        ggplot(p3, aes(x = parent_education, y = avg_score))+
            geom_col(aes(fill = subject), width = 0.7)})
    
    #plot4
    queryp4 <- "SELECT lunch, 'math' AS 'subject', AVG(math) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY lunch 
              UNION SELECT lunch, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY lunch 
              UNION SELECT lunch, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY lunch;"
    p4 <- dbGetQuery(pool, queryp4)
    
    refreshData <- reactive({
        invalidateLater(1000, session) 
        p4(pool)
    })
    output$p4 <- renderPlot({
        invalidateLater(1000)
        ggplot(p4, aes(x = lunch, y = avg_score))+
            geom_col(aes(fill = subject), width = 0.7)})
    
    #plot5
    queryp5 <- "SELECT prep_course, 'math' AS 'subject', AVG(math) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY prep_course 
              UNION SELECT prep_course, 'reading' AS 'subject', AVG(reading) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY prep_course 
              UNION SELECT prep_course, 'writing' AS 'subject', AVG(writing) AS 'avg_score'
              	FROM studentperformance
              	GROUP BY prep_course;"
    p5 <- dbGetQuery(pool, queryp5)
    
    refreshData <- reactive({
        invalidateLater(1000, session) 
        p5(pool)
    })
    output$p5 <- renderPlot({
        invalidateLater(1000)
        ggplot(p5, aes(x = prep_course, y = avg_score))+
            geom_col(aes(fill = subject), width = 0.7)})
    
}

shinyApp(ui, server)
