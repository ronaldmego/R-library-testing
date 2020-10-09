library(taskscheduleR)


fichero <- "C:\\Users\\ronald.mego\\Documents\\PeruQuiosco_ConnectMySQL.R"

#cat(readLines(fichero), sep = "\n")

#taskscheduleR:::taskschedulerAddin()

h<-'01:15:00'  #hora a la que correra el proceso

taskscheduler_create(taskname = "PQ_Altas_Automatizacion", 
                     rscript = fichero,
                     schedule = "DAILY", 
#                     starttime = format(Sys.time(), "%H:%M:%S"), 
                     starttime = h, 
#                     startdate = format(Sys.time(), "%d/%m/%Y")),
                     startdate = format(Sys.time(), "%m/%d/%Y"))




#parar
taskscheduler_stop('PQ_Altas_Automatizacion')

#borrar
taskscheduler_delete('PQ_Altas_Automatizacion')

#probar ahora
taskscheduler_runnow('PQ_Altas_Automatizacion')

#listar tasks
taskscheduler_ls()