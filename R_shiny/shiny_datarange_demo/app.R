

#data
library(dplyr)
library(jsonlite)

l = readLines(paste0("https://api.tfl.gov.uk/AccidentStats/2015"), encoding="UTF-8", warn=FALSE)
d = fromJSON(l)

accidents <- data.frame(lapply(as.data.frame(d), as.character), stringsAsFactors=FALSE)

#also make sure data is in date format
accidents$date2 <- as.Date(accidents$date, "%Y-%m-%d")
#fin data


ui <- fluidPage(
  titlePanel("Accidents in 2015"),
  
  sidebarLayout(
    sidebarPanel( 
      #date selector goes here 
      dateRangeInput("Date range", inputId = "date_range",
                     start = "2015-01-01",
                     end = "2015-12-31",
                     format = "yyyy-mm-dd")
    ),
    mainPanel(
      #plot output goes here
      plotOutput("ksiPlot")
    )
  )
)

server <- function(input, output) {
  #filter data based on dates
  dateFiltered <- reactive({accidents %>% filter(date2 %in% seq(input$date_range[1],     input$date_range[2], by = "day"))
  })
  #reactive plot
  output$ksiPlot <- renderPlot({
    data <- dateFiltered() 
    c <- ggplot(data,aes(x = factor(severity))) 
    c + geom_bar() +  
      xlab("Severity of incident") + 
      ylab("Number of incidents") 
    
  })
  
  
}


shinyApp(ui = ui, server = server)