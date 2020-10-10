sessionInfo()
memory.limit()
gc()

library(bigrquery)
library(assertthat)


sql_string <-'SELECT * FROM [Analitica.rm_audiencias_jul_fase3] where V_notas_valla>0 and flag_ecoid>0' 

query_results <- query_exec(sql_string, 
                            project = "dynamic-bongo-165917",
                            max_pages = Inf)

head(query_results)

#min(query_results$date)
#max(query_results$date)

setwd("D:/Mego/Big_Data/Outputs")
write.csv(query_results,"rm_audiencias_jul_fase3.csv",row.names = FALSE)

rm(query_results,sql_string)