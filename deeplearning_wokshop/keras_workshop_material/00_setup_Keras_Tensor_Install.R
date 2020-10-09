
#remove.packages("keras")
#remove.packages("tensorflow")
#remove.packages("tfruns")

#tensorflow
######################################### instalar previamente reiniciando R ############
library(devtools)
devtools::install_github("rstudio/tensorflow", type = "source", dependencies = TRUE)


library('tensorflow')

#lo instale en ambiente virtual r-tf
tensorflow::install_tensorflow(version = "1.15.0-gpu", method = "conda", envname = "r-tf")


#para validar si se instalo bien debe decir TRUE
reticulate::py_module_available('tensorflow')


#keras
######################################### instalar previamente reiniciando R ############
library(devtools)
devtools::install_github("rstudio/keras", type = "source", dependencies = TRUE)

#lo instale en ambiente virtual r-tf
library('keras')
keras::install_keras(version = "1.15.0-gpu",method = "conda",envname = "r-tf")


#para validar si se instalo bien
is_keras_available()


#############






