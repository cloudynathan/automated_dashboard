#automated query and dashboard

suppressWarnings(suppressMessages(library(taskscheduleR)))
suppressWarnings(suppressMessages(library(car)))
suppressWarnings(suppressMessages(library(RMySQL)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(shinydashboard)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(dplyr)))

psswd <- .rs.askForPassword("Database Password:")
mysqlconnection <- dbConnect(MySQL(), user='root', password=psswd, dbname='studentperformance', host='localhost')
dbListTables(mysqlconnection)

myQuery1 <- "SELECT * FROM studentperformance;"
df <- dbGetQuery(mysqlconnection, myQuery1)
#import data from mySQL

df <- df[complete.cases(df),]
anyNA(df)

colnames(df)[colnames(df) == 'race/ethnicity'] <- 'race_ethnicity'
colnames(df)[colnames(df) == 'parental level of education'] <- 'parent_education'
colnames(df)[colnames(df) == 'test preparation course'] <- 'prep_course'
colnames(df)[colnames(df) == 'math score'] <- 'math'
colnames(df)[colnames(df) == 'reading score'] <- 'reading'
colnames(df)[colnames(df) == 'writing score'] <- 'writing'

df$gender <- as.factor(df$gender)

unique(df$race_ethnicity)
df$race_ethnicity <- car::recode(df$race_ethnicity, 
                                "'group A'=1; 
                                 'group B'=2;
                                 'group C'=3;
                                 'group D'=4;
                                 'group E'=5")
df$race_ethnicity <- as.factor(df$race_ethnicity)

unique(df$parent_education)
df$parent_education <- car::recode(df$parent_education, 
                                 "'some high school'=1; 
                                 'high school'=2;
                                 'associate\\'s degree'=3;
                                 'some college'=4;
                                 'bachelor\\'s degree'=5;
                                 'master\\'s degree'=6")
df$parent_education <- as.factor(df$parent_education)
levels(df$parent_education) <- c('somehigh','high','associate','somecollege','bachelor','master')

df$lunch <- car::recode(df$lunch, "'free/reduced'=1; 'standard'=2")
df$lunch <- as.factor(df$lunch)
levels(df$lunch) <- c('freereduced','standard')

df$prep_course <- as.factor(df$prep_course)
df$prep_course <- car::recode(df$prep_course, "'none'=0; 'completed'=1")
levels(df$prep_course) <- c('none','completed')
#########################
df1 <- data.frame("gender"=df$gender,
                  "math"=df$math,
                  "reading"=df$reading,
                  "writing"=df$writing)
df1agg <- aggregate(df1, by=list(df$gender), FUN=mean)
df1agg$gender = NULL
colnames(df1agg)[colnames(df1agg) == 'Group.1'] <- 'gender'

df1agglong <- reshape(df1agg, direction = "long", varying = list(names(df1agg)[2:4]), v.names = "avg_score", 
        idvar = "gender", timevar = "subject", times = c("math","reading","writing"))
rownames(df1agglong) <- 1:nrow(df1agglong)

attributes(df1agglong) <- NULL
df1agglong <- as.data.frame(df1agglong)

names(df1agglong) <- c("gender", "subject", "avg_score")

p1 <- ggplot(df1agglong, aes(x = gender, y = avg_score))+
  geom_col(aes(fill = subject), width = 0.7)
p1
##

df2 <- data.frame("race_ethnicity"=df$race_ethnicity,
                  "math"=df$math,
                  "reading"=df$reading,
                  "writing"=df$writing)
df2agg <- aggregate(df2, by=list(df$race_ethnicity), FUN=mean)
df2agg$race_ethnicity = NULL
colnames(df2agg)[colnames(df2agg) == 'Group.1'] <- 'race_ethnicity'

df2agglong <- reshape(df2agg, direction = "long", varying = list(names(df2agg)[2:4]), v.names = "avg_score", 
                      idvar = "race_ethnicity", timevar = "subject", times = c("math","reading","writing"))
rownames(df2agglong) <- 1:nrow(df2agglong)

attributes(df2agglong) <- NULL
df2agglong <- as.data.frame(df2agglong)

names(df2agglong) <- c("race_ethnicity", "subject", "avg_score")

p2 <- ggplot(df2agglong, aes(x = race_ethnicity, y = avg_score))+
  geom_col(aes(fill = subject), width = 0.7)
p2
##
df3 <- data.frame("parent_education"=df$parent_education,
                  "math"=df$math,
                  "reading"=df$reading,
                  "writing"=df$writing)
df3agg <- aggregate(df3, by=list(df$parent_education), FUN=mean)
df3agg$parent_education = NULL
colnames(df3agg)[colnames(df3agg) == 'Group.1'] <- 'parent_education'

df3agglong <- reshape(df3agg, direction = "long", varying = list(names(df3agg)[2:4]), v.names = "avg_score", 
                      idvar = "parent_education", timevar = "subject", times = c("math","reading","writing"))
rownames(df3agglong) <- 1:nrow(df3agglong)

attributes(df3agglong) <- NULL
df3agglong <- as.data.frame(df3agglong)

names(df3agglong) <- c("parent_education", "subject", "avg_score")

p3 <- ggplot(df3agglong, aes(x = parent_education, y = avg_score))+
  geom_col(aes(fill = subject), width = 0.7)
p3
##
df4 <- data.frame("lunch"=df$lunch,
                  "math"=df$math,
                  "reading"=df$reading,
                  "writing"=df$writing)
df4agg <- aggregate(df4, by=list(df$lunch), FUN=mean)
df4agg$lunch = NULL
colnames(df4agg)[colnames(df4agg) == 'Group.1'] <- 'lunch'

df4agglong <- reshape(df4agg, direction = "long", varying = list(names(df4agg)[2:4]), v.names = "avg_score", 
                      idvar = "lunch", timevar = "subject", times = c("math","reading","writing"))
rownames(df4agglong) <- 1:nrow(df4agglong)

attributes(df4agglong) <- NULL
df4agglong <- as.data.frame(df4agglong)

names(df4agglong) <- c("lunch", "subject", "avg_score")

p4 <- ggplot(df4agglong, aes(x = lunch, y = avg_score))+
  geom_col(aes(fill = subject), width = 0.7)
p4
##
df5 <- data.frame("prep_course"=df$prep_course,
                  "math"=df$math,
                  "reading"=df$reading,
                  "writing"=df$writing)
df5agg <- aggregate(df5, by=list(df$prep_course), FUN=mean)
df5agg$prep_course = NULL
colnames(df5agg)[colnames(df5agg) == 'Group.1'] <- 'prep_course'

df5agglong <- reshape(df5agg, direction = "long", varying = list(names(df5agg)[2:4]), v.names = "avg_score", 
                      idvar = "prep_course", timevar = "subject", times = c("math","reading","writing"))
rownames(df5agglong) <- 1:nrow(df5agglong)

attributes(df5agglong) <- NULL
df5agglong <- as.data.frame(df5agglong)

names(df5agglong) <- c("prep_course", "subject", "avg_score")

p5 <- ggplot(df5agglong, aes(x = prep_course, y = avg_score))+
  geom_col(aes(fill = subject), width = 0.7)
p5

#########################

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

server <- function(input, output){
output$p1 <- renderPlot({ggplot(df1agglong, aes(x = gender, y = avg_score))+
    geom_col(aes(fill = subject), width = 0.7)})

output$p2 <- renderPlot({ggplot(df2agglong, aes(x = race_ethnicity, y = avg_score))+
    geom_col(aes(fill = subject), width = 0.7)})

output$p3 <- renderPlot({ggplot(df3agglong, aes(x = parent_education, y = avg_score))+
    geom_col(aes(fill = subject), width = 0.7)})

output$p4 <- renderPlot({ggplot(df4agglong, aes(x = lunch, y = avg_score))+
    geom_col(aes(fill = subject), width = 0.7)})

output$p5 <- renderPlot({ggplot(df5agglong, aes(x = prep_course, y = avg_score))+
    geom_col(aes(fill = subject), width = 0.7)})}


shinyApp(ui, server)


