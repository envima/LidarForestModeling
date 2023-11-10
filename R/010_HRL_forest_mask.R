#'@name 010_HRL_forest_mask.R
#'@datasource https://land.copernicus.eu/pan-european/high-resolution-layers/forests/forest-type-1/status-maps/forest-type-2018?tab=metadata
#'@date 22.03.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description create forest mask fitting for force data


# 1 - set up ####
#---------------#

libs=c("tidyverse","sf","dplyr","raster","terra")
lapply(libs, require, character.only = TRUE)



r = terra::rast("force/mosaic/2019-2021_001-365_HL_TSA_SEN2L_NIR_FBM.vrt")

hrlFiles = list.files("HRL/FTY_2018_010m_de_03035_v010/DATA", pattern = ".tif$", full.names = TRUE)
hrl = merge_crop_raster(listOfFiles = hrlFiles )

hrl2 = terra::rast(hrl)
hrl2= terra::project(hrl2, crs(r))

border = sf::read_sf("border/RLP_4326.gpkg")
border = sf::st_transform(border, crs(hrl2))

hrl3 = terra::crop(hrl2, border)
hrl4 = terra::resample(x=hrl3, y=r, method="near")

hrl4[hrl4 == 0]<-NA
hrl5 = terra::mask(hrl4, vect(border))
hrl5[hrl5 > 0]<-1
terra::writeRaster(hrl5, "HRL/HRL_force.tif", overwrite=T)


# for lidar data: reproject to 25832
hrl5 = terra::project(hrl5, "epsg:25832")

terra::writeRaster(hrl5, "HRL/HRL_force_RLP_25832.tif", overwrite=T)


hrl5 = terra::project(hrl5, crs(r))
