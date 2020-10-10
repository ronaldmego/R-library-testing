#https://www.datacareer.de/blog/connect-to-postgresql-with-r-a-step-by-step-example/

#install.packages('RPostgres')
#install.packages('RPostgreSQL')

#save.image(file = "C:/Users/ronald.mego/Documents/tags.RData")
#load("C:/Users/ronald.mego/Documents/tags.RData")

library(RPostgres)
library(DBI)

db <- 'content_dashboard'  #provide the name of your db
host_db <- 'xxxx.rds.amazonaws.com' #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  
db_port <- '5432'  # or any other port specified by the DBA
db_user <- 'teamsignwall'
db_password <-'xxxxxx'

#conexion
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)

#lista de tablas
#dbListTables(con)


tags<-dbGetQuery(con, "select brand,id_page,
       json_array_elements(tags::json)->>'slug' as slug_tag,
       json_array_elements(tags::json)->>'description' as description_tag,
       json_array_elements(tags::json)->>'text' as text_tag
from 
news.vw_page 
where 
brand = 'elcomercio'")

write.csv(tags,"C://Users//ronald.mego//Documents//Outputs//tags_202007.csv",row.names = FALSE)

dbDisconnect(con) 