#'@name 100_reproject_predictions_for_mapping.R
#'@date 06.07.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description reproject data to map in qgis and with leaflet


# 1 - setup ####
#--------------#

library(terra)

# 2 - predictions ####
#--------------------#

l=list.files("data/002_modelling/prediction", pattern="Lidar_pred.tif$", full.names = T)


for (i in l){
  if(!file.exists(gsub("_pred.tif","_epsg25832_pred.tif", i))){
    pred=terra::rast(i)
    pred=terra::project(pred, "epsg:25832", method="near")
    terra::writeRaster(pred, gsub("_pred.tif","_epsg25832_pred.tif", i))
    rm(pred)
  }
}


for (i in l){
  if(!file.exists(gsub("_pred.tif","_epsg3857_pred.tif", i))){
    pred=terra::rast(i)
    pred=terra::project(pred, "epsg:3857", method="near")
    terra::writeRaster(pred, gsub("_pred.tif","_epsg3857_pred.tif", i))
    rm(pred)
  }
}




