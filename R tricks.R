#mis accesos rapidos

#limpiar todas las variables, no usar en rmarkdown
rm(list=ls()) #para limpiar todo el workspace
rm(Variable) #para remover una variable especifica del workspace
memory.limit() #tope de memoria
gc() #para liberar memoria
setwd("D:/Mego/Big_Data") #para setear working directory

library(tidyverse) #libreria top

sessionInfo() #configuracion local
Sys.getlocale() #configuracion local


#para setear configuracion a ingles
Sys.setlocale("LC_ALL","English")

#creando un dataframe from scratch
orden<-c(0,1,2,3,4,5,6)
seg<-  c(0,3,4,1,6,2,5)
n_seg<-c('na','local','economista','internacional','politico','pelotero','pelotero int')
df_seg<-data.frame(orden,seg,n_seg)

#para setear una ruta:
#setwd("D:/Mego/Big_Data/Outputs")

#para leer csv con ecoding por si acaso las tildes
df <- read.csv("D:/xx.csv",header = T,encoding='UTF-8')

#leer csv separado por ';'
setwd("D:/Mego/Big_Data/Inputs")
d_enrq <- read.csv2("202006_Audiencias.csv",header = T)

#para grabar csv sin el indice y delimitado por ";"
write.csv2(tag_reg,"tag_reg.csv",row.names = FALSE)


#para leer excel y pedirle que setee formatyo fecha, texto y que para lo demas adivine:
library(readxl)
x<- read_excel("20200710_RegistradosARC.xlsx",sheet='PDE',col_types = c("date", "text", "guess", "guess"))

#otra opcion para leer y escribir excel
library(openxlsx)
read.xlsx("20200710_RegistradosARC.xlsx") #https://rdrr.io/cran/openxlsx/man/read.xlsx.html

write.xlsx(Print_PQ_CO_res_1,"D:/Mego/Big_Data/Outputs/Print_PQ_CO_res_1.xlsx", 
  col.names=TRUE, row.names=FALSE)

#graba con estilo poniendo la hora de generacion

hora<-chartr(':-','..',Sys.time())
hora<-chartr(' ','_',hora)
ruta<-"D:/Mego/Big_Data/Outputs/"
nombre<-"pq_t"
file<- paste0(ruta,nombre,"_",hora,".xlsx")
write.xlsx(df_pq_t,file,col.names=TRUE, row.names=FALSE)




#para grabar una data omitiendo columnas y usando csv2 para separar por ";" en vez de ";":
write.csv2(subset(d_enrq_reg, 
            select=-c(seg,suscriptor,choques_pay,choques_prem,data_seg)),
           "data_enriquecida.csv",row.names = FALSE)

#para grabar espacio de trabajo
setwd("D:/Mego/Big_Data")
#save.image(file = "PQ_analisis.RData")
#load("PQ_analisis.RData")

#para usar SQL en R:
library(sqldf)
sqldf('select edad,count(1) cantidad from t group by 1 order by 2 desc limit 10')

#para renombrar campos "nuevo nombre" - "antiguo nombre":
df <- rename(df, c('new'=old))
#para ver tipos de datos de un dataframe
sapply(df,class)

#para eliminar registros basados en una condicion:

#elimina rows basado en criterios
mtcars<-subset(mtcars, cyl==6 & am!=0) #ejem te quedas con estos

df <- subset(df,Var!="value")  #ejem eliminas estos

#para capturar el anio de una fecha
library(lubridate)
PlantaPQ_Mon_3$year<-year(PlantaPQ_Mon_3$fch_registro)

#para conocer el numero e filas
dim(registradosARC)[1]
nrow(registradosARC_com)

#para conocer la completitud de la data:
data.frame(sapply(d_enrq_reg, function(x) sum(is.na(x))))


#para reemplazar valores nulos con otro valor.
t$data_seg[is.na(t$data_seg)] <- 0

#bloque para borrar texto a partir de @ hasta el final
regARC$aux<-substr(regARC$email,
         regexpr("@",regARC$email),
         nchar(regARC$email))

#para hacer intervalos de igual tamanio, ejemplo metodo cut en python:
library(mltools)

	#separa la data en 10 grupos de igual tamanio
	t$r_edad<-bin_data(t$edad,bins=10,binType='quantile',boundaryType="[lorc")

	#separa la data en grupos segun los intervalos definidos y cerrado por la izquierda:
	t$r_edad<-bin_data(t$edad,bins=c(-Inf,17,24,34,45, Inf),binType='explicit',boundaryType="[lorc")


#para pasar a formato fecha de distintos formatos origen con try format:
t$Fecha_Nacimiento_fixed <- as.Date(t$Fecha_Nacimiento, tryFormats = c("%d/%m/%Y","%Y-%m-%d","%Y/%m/%d"))
#aux <- as.POSIXct("2020-05-31 23:59:59")

#para pasar texto a minusculas y reemplazar caracteres especiales:
diccionario_tags$Tag<- tolower(diccionario_tags$Tag)
diccionario_tags$Tag_fixed <- chartr("Ã¡Ã©Ã­Ã³ÃºÃ±-","aeioun_",diccionario_tags$Tag)

#mirando valores unicos de una columna
table(df$column)

#para anexar campos, usar library(dplyr)
t<-left_join(t,data_seg)
rm_reg_seg<-left_join(rm_reg_seg,aux2[,c('ecoid_full','seg')])  #solo algunos campos

#cruzando left join y anexando columnas y luego reeemplazando los vacios del join con otra columna
prod_tags_idnota<-left_join(prod_tags_idnota,agregador_tags)
y<-ifelse(is.na(prod_tags_idnota$TagAG),prod_tags_idnota$Tag_fixed,prod_tags_idnota$TagAG)

#encontrando valores vacios y reemplazando con NA
t$edad_fixed[is.na(t$Rango_Edad)]<-NA


#encontrando columnas duplicadas
nrow(df[duplicated(df$id), ])

#elimina duplicados
df<- distinct(df, id, .keep_all = TRUE)

#para mirar la frecuencia de un campo , solo top10
y<-as.data.frame(table(tag_reg$TagAG))
head(y[order(-y$Freq),],10)

#ordenar un dataframe por una columna y mirando los 10 primeros registros
head(arrange(df,desc(x)),10) $orden descendente libreria dplyr
head(arrange(df,x),10) #$orden ascendente libreria dplyr

#agregar la cantidad de vales por documento de la data club usando funcion suma y mostrar los top
x<-aggregate(vales~numero_documento,data=Club_vales,sum)
x[order(-x$vales),]

#para agregar conteo por year y month:
df1 %>% count(Year, Month) #libreria dplyr

#otras forma de agregar por dos variables y contar
aggregate(x ~ Year + Month, data = df, FUN = length)

df %>% group_by(year, month) %>% summarise(number = n())

df %>% group_by(year, month) %>% tally()

#agregar los numeros de fila a una data para ordenar
data$ID <- seq.int(nrow(data))

#buscando vacios y contando completitud
data.frame(sapply(d_seg_idnota_lec, function(x) sum(is.na(x))))

#asignar nombres a las columnas del df:
colnames(datos) <- nombres[[2]]$Property

#totales de todas las columnas si son numericas:
totales_columna<-as.data.frame(colSums(Filter(is.numeric, rm_reg_seg[-1:-5]))) #ignora las 5 primeras columnas

#para pasar fechas a formato periodo yyyymm
p_paywall$Month_Yr<-format(as.Date(p_paywall$date), "%Y%m")		  
		  
library(lubridate) #para tomar el anio de la fecha
PlantaPQ_Mon_3$year<-year(PlantaPQ_Mon_3$fch_registro)

#uso del if
if (test_expression)
	{
statement1
} else {
statement2
}

#loops y funciones

#creando una funcion que asigna edad segun fecha de nacimiento y fecha de referencia:
age = function(from, to) { 
  from_lt = as.POSIXlt(from) 
  to_lt = as.POSIXlt(to) 
  
  age = to_lt$year - from_lt$year 
  
  ifelse(to_lt$mon < from_lt$mon | 
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday), 
         age - 1, age) 
}

	#ejemplo de uso
	date.ref <- Sys.Date()
	t$edad <- age(t$Fecha_Nacimiento,date.ref)

#loop

for (i in 2020:2010){print(i)} # para ir para atras
for (i in seq(2020, 2010, by=-2)){print(i)} #para ir para atras de 2 en 2

#creando un loop que si en caso encuentra un error lo salta

idnota<-c(
'XXXXX',
'YYYYY',
'ZZZZZ')
idnota<-data.frame(idnota)

arc_df <- data.frame()
for(i in 1:nrow(idnota)){
  skip_to_next <- FALSE #para next
  url_arc <-paste('https://api.CCCCCC.arcWWWWWWWWW.com/draft/v1/story/',idnota[i,],'/revision',sep='')
  arc0 <- GET(url_arc,headers_arc)
  arc1 <- fromJSON(content(arc0, type = "text"))
  arc2<-arc1[["revisions"]]
  
  tryCatch(  #para next
  arc3<-t(apply(arc2, 1, unlist))
  ,error = function(e) { skip_to_next <<- TRUE})  #para next
  if(skip_to_next) { next } #para next
  
  arc3<-as.data.frame(arc3)
  
  tryCatch(  #para next
  arc<-arc3[arc3$type=='PUBLISHED',c('id','document_id','ans.created_date','ans.headlines.basic',
       'ans.headlines.meta_title','ans.last_updated_date','ans.revision','ans.display_date',
       'ans.first_publish_date','ans.publish_date','created_at','type')]
  ,error = function(e) { skip_to_next <<- TRUE})  #para next
  if(skip_to_next) { next } #para next
  
  arc_df<-rbind(arc_df,arc)
  print(paste(idnota[i,],i/nrow(idnota),i,sep="     "))
  Sys.sleep(1) #se detiene un segundo
}

#para dibujar un barplot de una tabla de frecuencias de una variable 'var'
barplot(df$freq, names.arg = df$var)

#loop en rango de fechas
start <- as.Date("01-08-14",format="%d-%m-%y")
end   <- as.Date("08-09-14",format="%d-%m-%y")

theDate <- start

while (theDate <= end)
{
  print(paste0("http://website.com/api/",format(theDate,"%d%b%y")))
  theDate <- theDate + 1                    
}








#Librerias instaladas y sus versiones
ip <- as.data.frame(installed.packages()[,c(1,3:4)])
rownames(ip) <- NULL
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
print(ip, row.names=FALSE)
#para ver una descripción de las librerias instaladas
library()
#Comando para instalar librerias recomendadas, excepto las ya instaladas
list.of.packages <- c(####### recomendados
  "dplyr", "plyr", "data.table", "missForest", "missMDA",
  "outliers", "evir", "features", "RRF", "FactoMineR", "CCP",
  "ggplot2", "googleVis", "car", "randomForest",
  "rminer", "CORElearn", "caret", "cba","mice",
  "Rankcluster", "forecast", "ltsa", "survival", "BaSTA",
  "lsmeans", "comparison", "regtest", "ACD", "binomTools", 
  "Daim", "clusteval", "sigclust", "pROC", "timeROC", "Rcpp",
  "parallel", "XML", "httr", "rjson", "jsonlite", "shiny",
  "rmarkdown", "tm", "sqldf", "RODBC","xlsReadWrite",
  ###### mios
  "rpart","rattle","party","tree","MVN",
  ###### no encuentro
  "openNLP", "MongoDB","rCharts", "bigrf")
new.packages <- list.of.packages[!(list.of.packages 
                                   %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)})
