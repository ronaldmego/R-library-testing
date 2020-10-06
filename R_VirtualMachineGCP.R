#https://anderfernandez.com/blog/crear-maquina-virutal-con-r-google-cloud/

#pasos para crear la maquina virtual
rm(list = ls())


#el key tiene rol de:

# 'Compute Security Admin role' ->para compute.firewalls.create (aunque creo q es demasiado grande)
# 'Compute engine admin v1'->para crar maquinas virtuales
# 'Compute engine admin beta'->para crear instancias
# 'service account user'->para conectarse a account service
#account_key = 'thematic-rider-281223-8ae19251b5fa.json'

project = "thematic-rider-281223"
zona = "us-central1-b"
account_key = 'gcp_virtual_machine_mego.json'


Sys.setenv(GCE_AUTH_FILE = account_key,
           GCE_DEFAULT_PROJECT_ID = project,
           GCE_DEFAULT_ZONE = zona)

library(googleComputeEngineR)

#para crear la maquina virtual
vm <- gce_vm(template = "rstudio", 
             name="demo-rstudio",
             predefined_type = "f1-micro", 
             username = "XXXXXX@gmail.com",
             password = "XXXXXXX")

#para detener la maquina virtual
gce_vm_stop("demo-rstudio")