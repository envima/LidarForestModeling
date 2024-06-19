#'@name 010_HRL_forest_mask.R
#'@datasource https://land.copernicus.eu/pan-european/high-resolution-layers/forests/forest-type-1/status-maps/forest-type-2018?tab=metadata
#'@date 22.03.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description create forest mask fitting for force data


# 1 - set up ####
#---------------#

libs=c("tidyverse","sf","dplyr","raster","terra", "RCurl")
lapply(libs, require, character.only = TRUE)

# 2- download the border of the study area ####
#---------------------------------------------#

# url to download the federal state border from the Landesamt für Vermessung und Geobasisinformation
URL <- "http://geo5.service24.rlp.de/wfs/verwaltungsgrenzen_rp.fcgi?&request=GetFeature&TYPENAME=landesgrenze_rlp&VERSION=1.1.0&SERVICE=WFS&OUTPUTFORMAT=SHAPEZIP"
# download file 
download.file(URL,destfile="data/001_raw_data/border/border.zip", method="libcurl", mode = "wb")
# extract zip file
unzip("data/001_raw_data/border/border.zip",exdir="data/001_raw_data/border");rm(URL)
# read shapefile
border = sf::read_sf("data/001_raw_data/border/landesgrenze_rlp.shp")
sf::st_crs(border)<- "epsg:25832"
border<- sf::st_transform(border, "epsg:4326")
sf::write_sf(border, "data/001_raw_data/border/RLP_4326.gpkg")
border = sf::read_sf("data/001_raw_data/border/RLP_4326.gpkg")
# clean up
unlink(c("data/001_raw_data/border/border.zip", "data/001_raw_data/border/landesgrenze_rlp.shp", "data/001_raw_data/border/landesgrenze_rlp.shx", "data/001_raw_data/border/landesgrenze_rlp.dbf"))

# 2 - download HRL data and process ####
#--------------------------------------#

# load the NIR band of the Sentinel-2 data processed by FORCE
r = terra::rast("data/001_raw_data/force/mosaic/2019-2021_001-365_HL_TSA_SEN2L_NIR_FBM.vrt")

############################################################################################################
# download the HRL files via the https://land.copernicus.eu for the study area and extract (login needed)
# check if the path to you extracted folder is the same or needs to be adjusted
############################################################################################################

# then list all files
hrlFiles = list.files("data/001_raw_data/HRL/FTY_2018_010m_de_03035_v010/DATA", pattern = ".tif$", full.names = TRUE)
# create spatialRaster
hrl=terra::sprc(hrlFiles)
hrl=terra::merge(hrl)
# use projection of FORCE data
hrl= terra::project(hrl, crs(r))

border = sf::read_sf("border/RLP_4326.gpkg")
border = sf::st_transform(border, crs(hrl))

hrl = terra::crop(hrl, border)
hrl = terra::resample(x=hrl, y=r, method="near")

hrl[hrl == 0]<-NA
hrl = terra::mask(hrl, vect(border))
hrl[hrl > 0]<-1
terra::writeRaster(hrl, "data/001_raw_data/HRL/HRL_force.tif", overwrite=T)


# for lidar data: reproject to 25832
hrl = terra::project(hrl, "epsg:25832")
terra::writeRaster(hrl5, "data/001_raw_data/HRL/HRL_force_RLP_25832.tif", overwrite=T)
