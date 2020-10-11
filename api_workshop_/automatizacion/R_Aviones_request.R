# Tutorial de automatización de scripts
# https://anderfernandez.com/automatizar-scripts-de-r-en-windows-y-mac/


#rm(list = ls())
setwd("D:/Mego/Big_Data/Demo")
library(httr)
library(jsonlite)

time<-as.character(Sys.time())
time <- chartr(":","_",time)

nombre <- paste0(time,".csv")
url = "https://opensky-network.org/api/states/all"
datos <- GET(url)
datos <- fromJSON(content(datos, type = "text"))
datos <- datos[["states"]]

write.csv2(datos,nombre, row.names = FALSE)
