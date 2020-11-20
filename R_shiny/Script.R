libs = c("httr","shiny","jsonlite","ggplot2","plotly","forecast","dplyr","lubridate")
for(i in libs){if (!i %in% installed.packages()) install.packages(i)}
sapply(libs, require, character.only = TRUE)


simbolo = "A"
fecha_inicio = as.numeric(as.POSIXct(Sys.time()-360))
fecha_fin =  as.numeric(as.POSIXct(Sys.time()-5)) 

url = paste0("https://finnhub.io/api/v1/stock/candle?symbol=",simbolo,
             "&resolution=1&from=",fecha_inicio,"&to=",fecha_fin,
             "&token=bsj2vvvrh5rcthrm5n10")


resp = GET(url)
data = fromJSON(content(resp, type = "text"))

#Nos quedamos con la cotización y timestamp
datos = data.frame(cotizacion = data[[1]], timestamp = data[[6]])

# Arreglamos la fecha
datos$timestamp = as.POSIXct(datos$timestamp, origin = "1970-01-01")



# Hacemo la predicción
# Ref: https://bookdown.org/singh_pratap_tejendra/intro_time_series_r/neural-networks-in-time-series-analysis.html


datos_red = datos %>%
  mutate(fecha = as.Date(timestamp),
         tipo = "Valor Histórico") %>%
  group_by(fecha) %>%
  slice(1) %>%
  select(-timestamp)
  
tiempo_predecir = 100
lags_considerar = 30

fit = nnetar(datos_red$cotizacion, p = 30)
nnetforecast <- forecast(fit, h = tiempo_predecir)


# Convertimos la prediccion 
fechas_pred = max(datos_red$fecha)  +  c(1:tiempo_predecir)


predicciones = data.frame(
  cotizacion = nnetforecast$mean,
  fecha = fechas_pred,
  tipo = "Valor predicho"
)

datos_plot = bind_rows(datos_red, predicciones)


g = ggplot(datos_plot, aes(fecha, cotizacion, color = tipo)) + geom_line() +
  theme_minimal()+ theme(legend.position = "none") +
  labs(col = "")

ggplotly(g)


