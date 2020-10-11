#https://www.datacareer.de/blog/connect-to-postgresql-with-r-a-step-by-step-example/

#install.packages('RPostgres')
#install.packages('RPostgreSQL')

#save.image(file = "C:/Users/ronald.mego/Documents/tags.RData")
#load("C:/Users/ronald.mego/Documents/tags.RData")

library(RPostgres)
library(DBI)
library(openxlsx)

db <- 'content_dashboard'  #provide the name of your db
host_db <- 'sxxxx.rds.amazonaws.com' #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  
db_port <- '5432'  # or any other port specified by the DBA
db_user <- 'teamsignwall'
db_password <-'xxxxxx'

#conexion
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)

#lista de tablas
#dbListTables(con)


df_datamaster<-dbGetQuery(con, "select id_tiempo,desc_fuente,desc_comprador,sum(ingresos) as soles from googleads.fact_venta 
inner join googleads.dim_fuente on googleads.fact_venta.id_fuente = googleads.dim_fuente.id_fuente
inner join googleads.dim_comprador on googleads.fact_venta.id_comprador = googleads.dim_comprador.id_comprador
group by id_tiempo,desc_fuente,desc_comprador
order by id_tiempo,desc_fuente,desc_comprador")

#graba
hora<-chartr(':-','__',Sys.time())
nombre <- paste0("C://Users//ronald.mego//Google Drive//Compartido//datamaster_",
                 hora,".xlsx")
write.xlsx(df_datamaster,nombre,
           col.names=TRUE, row.names=FALSE)


dbDisconnect(con) 