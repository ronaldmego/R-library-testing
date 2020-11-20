library(httr)
library(shiny)
library(jsonlite)
library(ggplot2)
library(plotly)
library(forecast)
library(dplyr)
# libs = c("shiny","jsonlite","ggplot2","plotly","forecast","dplyr")
# #for(i in libs){if (!i %in% installed.packages()) install.packages(i)}
# sapply(libs, require, character.only = TRUE)

# Obtenemos las empresas 
url = "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=bsj2vvvrh5rcthrm5n10"
resp = GET(url)
codigos = fromJSON(content(resp, type = "text", encoding = "UTF-8"))
codigos = codigos[codigos$description!= "",]

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Predicción de cotización"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("company",
                        "Selecciona la empresa:",
                        choices = codigos$description
                        ),
            numericInput("lags", 
                        "Nº de Lags a usar",
                        min = 1, max = 30,
                        value = 30
                        ),
            numericInput("tiempo",
                        "Nº de Días a Predecir",
                        value = 30, 
                        min = 1,
                        max = 100
                        ),
            actionButton("boton",label = "Analizar")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    datos_cotizacion = eventReactive(input$boton ,{
        
        # Obtenemos el código de la empresa
        empresa = input$company
        simbolo = codigos$displaySymbol[codigos$description == empresa]
        
        # Construimos URL + petición
        fecha_inicio = as.numeric(as.POSIXct(Sys.time()-360))
        fecha_fin =  as.numeric(as.POSIXct(Sys.time()-5))
        
        url = paste0("https://finnhub.io/api/v1/stock/candle?symbol=",simbolo,
                     "&resolution=1&from=",fecha_inicio,"&to=",fecha_fin,
                     "&token=bq8922frh5rc96c0gnfg")
        
        
        resp = GET(url)
        data = fromJSON(content(resp, type = "text"))
        
        #Nos quedamos con la cotización y timestamp
        datos = data.frame(cotizacion = data[[1]], timestamp = data[[6]])
        
        # Arreglamos la fecha
        datos$timestamp = as.POSIXct(datos$timestamp, origin = "1970-01-01")
        
        # Lo último que pasamos es lo que devolverá el objeto reactivo
        datos
    })
    
    datos_final = eventReactive(datos_cotizacion(),{
        datos = datos_cotizacion()
        
        datos_red = datos %>%
            mutate(fecha = as.Date(timestamp),
                   tipo = "Valor Histórico") %>%
            group_by(fecha) %>%
            slice(1) %>%
            select(-timestamp)
        
        tiempo_predecir = input$tiempo
        lags_considerar = input$lags
        
        fit = nnetar(datos_red$cotizacion, p = lags_considerar)
        nnetforecast <- forecast(fit, h = tiempo_predecir)
        
        
        # Convertimos la prediccion 
        fechas_pred = max(datos_red$fecha)  +  c(1:tiempo_predecir)
        
        
        predicciones = data.frame(
            cotizacion = nnetforecast$mean,
            fecha = fechas_pred,
            tipo = "Valor predicho"
        )
        
        datos_plot = bind_rows(datos_red, predicciones)
        
        datos_plot
    })
    
    
    output$distPlot <- renderPlotly({
        
        datos = datos_final()
        
        g = ggplot(datos, aes(fecha, cotizacion, color = tipo)) + geom_line() +
            theme_minimal()+ theme(legend.position = "none") +
            labs(col = "")
        
        ggplotly(g)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
