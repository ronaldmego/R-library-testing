# Tutorial de automatización de scripts
# https://anderfernandez.com/automatizar-scripts-de-r-en-windows-y-mac/


#install.packages("taskscheduleR")
library(taskscheduleR)

##forma 1 de configurar automatizacion: buscar en el menu Tools / Addins

##forma 2 de configurar automatizacion: usar comando:
#taskscheduleR:::taskschedulerAddin()

#forma 3 de configurar automatizacion:

#fichero <- "C:\\Users\\Ander\\Desktop\\Automatizar_mtcars.R"

fichero <- "D:\\Mego\\Big_Data\\Demo\\DemoAutomatizacionconR_Aviones.R"


taskscheduler_create(taskname = "aviones", 
                     rscript = fichero,
                     schedule = "MINUTE", 
                     starttime = format(Sys.time(), "%H:%M:%S"),   #ojo verificar si este es el formato del sistema
                     startdate = format(Sys.time(), "%d/%m/%Y"))


#parar
taskscheduler_stop('aviones')

#borrar
taskscheduler_delete('aviones')

#listar tasks
taskscheduler_ls()