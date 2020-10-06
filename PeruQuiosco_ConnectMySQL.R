# 1. Library
library(RMySQL)
library(dplyr)
library(openxlsx)


# 2. Settings #solo funcionan en local
db_user <- 'XXXXX'
db_password <- 'XXXX'
db_name <- 'prod_quiosco2db'
db_host <- 'aurora02-cluster.cluster-ro-clz6pendayku.us-east-1.rds.amazonaws.com'
db_port <- 3306


# 3. Read data from db
mydb <-  dbConnect(MySQL(), user = db_user, password = db_password,
                   dbname = db_name, host = db_host, port = db_port)


db_table_a <- 'prod_quiosco2db.view_subscriptions_all'
db_table_b <- 'prod_quiosco2db.view_payment_siebel_all'

query_a <- paste0("select * from ", db_table_a)
rs_a <- dbSendQuery(mydb, query_a)
df_a <-  fetch(rs_a, n = -1) #para traer todos los registros

query_b <- paste0("select * from ", db_table_b)
rs_b <- dbSendQuery(mydb, query_b)
df_b <-  fetch(rs_b, n = -1) #para traer todos los registros

rm(rs_a,rs_b)


###Preparando para el Rbind df_a

df_a$pa_amount<-'' #no se usa
df_a$date_start<-''
df_a$date_anulled<-''
df_a$date_expiration<-''

df_a$nombre_prod<-ifelse((substr(df_a$prod_name,1,5)=='Revis'|substr(df_a$prod_name,1,5)=='Rueda'),
                         'Revistas',df_a$prod_name)

df_a$fecha_registro<-as.Date(df_a$date_register)
df_a$Canal<-'Web'
df_a$fecha_anulacion<-as.Date(df_a$date_annulled)

###Preparando para el Rbind df_b

df_b$department<-'' #nuevo
df_b$city<-'' #nuevo
df_b$country_code<-'' #nuevo
df_b$country_name<-'' #nuevo

df_b$subs_id<-''
df_b$date_renovation<-''
df_b$date_annulled<-''
df_b$subs_token<-''

df_b$nombre_prod<-ifelse((substr(df_b$prod_name,1,5)=='Revis'|substr(df_b$prod_name,1,5)=='Rueda'),
                         'Revistas',df_b$prod_name)

df_b$fecha_registro<-as.Date(df_b$date_register)
df_b$fecha_anulacion<-as.Date(df_b$date_expiration)
df_b$Canal<-'Call'


df_pq<-rbind(df_a,df_b)

#grabo el resultado

hora<-chartr(':-','__',Sys.time())



nombre <- paste0("C://Users//ronald.mego//Documents//Outputs/Altas_",
                 hora,".xlsx")

write.xlsx(df_pq,nombre,
           col.names=TRUE, row.names=FALSE, append=FALSE)

on.exit(dbDisconnect(mydb))