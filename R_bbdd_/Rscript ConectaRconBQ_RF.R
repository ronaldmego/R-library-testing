#https://attachmedia.com/blog/usando-la-potencia-de-bigquery-r-y-tableau-para-entender-mejor-al-usuario-hablemos-de-r/

install.packages("pkgbuild")
pkgbuild::find_rtools(debug = TRUE)

install.packages("bigrquery")
install.packages("assertthat")
install.packages("readr")
#install.packages('devtools')
#devtools::install_github("rstats-db/bigrquery")
#devtools::install_github("r-dbi/bigrquery")

library(bigrquery)
library(assertthat)

packageVersion("bigrquery")

#install.packages('googleAuthR')
#library(googleAuthR)
#gar_auth()
#gar_auth(email = "richard.fernandez@comercio.com.pe")



#options(gargle_quiet = FALSE)
#bq_auth()

#options(httr_oob_default = TRUE)

#bq_auth(email = "richard.fernandez@comercio.com.pe")

# Use your project ID here
#project_id <- "your-project-id" # put your project ID here

# Example query
#El Comercio: 21928896
#Gestión: 9043312
#Depor: 16646171
#Peru21: 9849434
#Correo: 43842143
#Trome: 33059813
#Ojo: 31245754
#Publimetro: 48994197
#Bocon: 31246731
sql_string <- "SELECT * FROM [reporteria.Navegacion_2020_06_05_min]"

# Execute the query and store the result
#El Comercio: dynamic-bongo-165917
#Gestión: ga-360-gestion
#Depor: ga-360-depor
#Peru21: ga-360-peru21
#Correo: ga-360-correo
#Trome: ga-360-trome
#Ojo: ga-360-ojo
#Publímetro: ga-360-elbocon
#Bocon: ga-360-elbocon
query_results <- query_exec(sql_string, 
                            project = "dynamic-bongo-165917",
                            max_pages = Inf)

#ga-360-gestion#query_results <- query_exec(sql_string, 
#                            project = "dynamic-bongo-165917",
#                            max_pages = Inf,
#                            useLegacySql = FALSE)

head(query_results)

min(query_results$date)
max(query_results$date)

setwd("D:/Mego/Big_Data/Browsers_CO_202006")
write.csv(query_results,"Navegacion_2020_06_05_min.csv",row.names = FALSE)

query_results <- NULL
