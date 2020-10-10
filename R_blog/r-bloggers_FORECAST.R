
#-------------------------------------------------------------------------------*
#https://www.r-bloggers.com/forcasting-natural-catastrophes-is-rather-difficult/
#-------------------------------------------------------------------------------*

#-------------------------------------------------------------------------------*
#https://www.r-bloggers.com/forecasting-with-daily-data/
#-------------------------------------------------------------------------------*
#Probando proyecciones de data diaria

#install.packages("forecast")
library(forecast)

# (c) Turkish electricity demand data.
# Daily data from 1 January 2000 to 31 December 2008.
telec <- read.csv("http://robjhyndman.com/data/turkey_elec.csv")
telec <- msts(telec, start=2000, seasonal.periods = c(7,354.37,365.25))