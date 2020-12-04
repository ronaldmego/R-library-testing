

#data
library(googleAuthR)
library(googleAnalyticsR)
library(ggplot2)
ga_auth(email='ronald.mego@comercio.com.pe')


f_ga_pv_bu_com<-function(inicio_f,fin_f,view)
{
  ga_pv_bu_com <- google_analytics(viewId = view, #vista
                                   date_range =c(inicio_f,fin_f), #rango de fechas
                                   metrics = c("pageviews","users"),  #metrica paginas vistas
                                   dimensions = "date", #dimension fecha
                                   max=-1) #sin limite
}

#fin data



library(shiny)
ui <- fluidPage(
  titlePanel("Paginas Vistas GA"),
  
  sidebarLayout(
    sidebarPanel( 
      #date selector goes here 
      dateRangeInput("Date range", inputId = "date_range",
                     start = Sys.Date()-30,
                     end = Sys.Date(),
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
  

  
  
  #view<-'21928896'

  dateFiltered <- reactive({
    view<-'21928896'
    #accidents %>% filter(date2 %in% seq(input$date_range[1],     input$date_range[2], by = "day"))
    test<-f_ga_pv_bu_com(input$date_range[1],input$date_range[2],view)
    
  })
  
  
  #reactive plot
  output$ksiPlot <- renderPlot({
    plot(test)
  })
  
  
}


shinyApp(ui = ui, server = server)