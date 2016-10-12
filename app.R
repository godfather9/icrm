library(shiny)
library(shinydashboard)
library(plotly)
library(quantmod)
library(ggplot2)

mydb <- read.csv("SynthData.csv")
#mydb$Date <- as.Date(as.character(mydb$Date), format = "%d-%m-%Y")
# minx <- min(mydb$Part.Number)
# maxx <- max(mydb$Part.Number)

# str(mydb$Part.Number)
# str(mydb$Unit.Cost)

# unique(mydb$Unit.Cost)
# unique(mydb$Part.Number)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      valueBox("KPI1", textOutput("one")),
      valueBox("KPI2", textOutput("two")),
      valueBox("KPI3", textOutput("three"))
      
      
    ),
    fluidRow(
      box(plotlyOutput("plot2", height = 200)),
      box(plotlyOutput("plot1", height = 200)),
      box(plotlyOutput("plot1", height = 200))
    ),
    fluidRow(
      
      box(width = 2000,
          column(10,
                 plotlyOutput("plot3", height = 250)),
          column(2,
                 selectInput("product", "Product",c("a"),
                             selectInput("time", "Time Frame", c("b"),
                                         selectInput("household_key","Household Key",c("c"))
                             ))
          )  
      )
    )))

server <- function(input, output) {
  output$plot1 <- renderPlotly(
    {
      plot_ly(x = mydb$Part.Number, y = mydb$Unit.Cost)
    }
  )
  output$plot2 <- renderPlotly(
    {
      p <- plot_ly(x = mydb$Unit.Cost, type = "histogram")
      layout(p, xaxis = list(title = "xaxis", autorange = T,
                             autotick = T))
    }
  )
  output$plot3 = renderPlot(
    ggplot(data=mydb, aes(x=S.No, y=dev.EDD, group=1)) +
      geom_line()+
      geom_point()
  )
}

shinyApp(ui = ui, server = server)