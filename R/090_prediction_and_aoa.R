#'@name 040_modelling.R
#'@date 20.06.2023
#'@author Lisa Bald [bald@staff.uni-marburg.de]
#'@description area wide prediction and aoa for tree species and successional stages


# 1 - set up ####
#---------------#

library(terra)
library(CAST)

# 2 - load predictors ####
#------------------------#

sentinel=lapply(list.files("data/001_raw_data/force/data/mosaic", pattern=".vrt", full.names = T), function(x){
  sentinel=terra::rast(x)
  sentinelNames=gsub("-","_",paste0(gsub("_FBM.vrt","",gsub("data/001_raw_data/force/data/mosaic/2019-2021_001-365_HL_TSA_SEN2L_","",x)), "_", names(sentinel)))
  names(sentinel)<- sentinelNames
  return(sentinel)
})

sentinel=terra::rast(sentinel)
lidar=terra::rast(list.files("data/001_raw_data/lidar/data/", pattern=".tif", full.names = T))
predictors=terra::rast(list(sentinel, lidar)); rm(sentinel,lidar)
# 3 - prediction 7 tree species ####
#----------------------------------#

for(i in c("7TS", "8TS")){
  if(!file.exists(sprintf("data/002_modelling/prediction/%s_SentinelLidar_pred.RDS", i))){
    # load model
    mod=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS",i))
    # spatial prediction of model 
    pred=terra::predict(predictors, model=mod, na.rm=T)
    
    terra::writeRaster(pred, sprintf("data/002_modelling/prediction/%s_SentinelLidar_pred.tif", i))
    saveRDS(pred, sprintf("data/002_modelling/prediction/%s_SentinelLidar_pred.RDS", i))
  } else {pred=readRDS(sprintf("data/002_modelling/prediction/%s_SentinelLidar_pred.RDS",i)) }
  
  for (BA in c( "La", "Lbk", "Lbl", "Dou", "Ei", "Fi", "Ki", "Bu", "Lb")){
    print(BA)
    if (BA %in% c("Lbk", "Lbl") && i == "7TS") next
    if (BA == "Lb" && i == "8TS") next
    
    if(!file.exists(sprintf("data/002_modelling/prediction/%s_%s_SentinelLidar_pred.tif", i, BA))){
      predBa=pred
      if (BA == "La"){
        predBa[predBa != levels(predBa)[[1]][levels(predBa)[[1]]$class == "Lä",]$value] <- NA
      } else { predBa[predBa != levels(predBa)[[1]][levels(predBa)[[1]]$class == BA,]$value] <- NA}
      
      mod=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", BA))
      predictors2=terra::subset(predictors, mod$selectedvars)
      predictors2=terra::mask(predictors2, predBa)
      if(BA =="Bu"){
        predictors3=predictors2
        predictors2[is.infinite(predictors2)]<- NA
      }
      pred2=terra::predict(predictors2, model=mod, na.rm=T)
      
      
      # save files
      saveRDS(pred2, sprintf("data/002_modelling/prediction/%s_%s_SentinelLidar_pred.RDS", i, BA))
      terra::writeRaster(pred2, sprintf("data/002_modelling/prediction/%s_%s_SentinelLidar_pred.tif", i, BA))
      rm(mod,predBa,predictors2,pred2)    
    }
  }
}



# 4 - Area of applicability ####
#------------------------------#




for (BA in c( "La", "Dou", "Ei", "Fi", "Ki", "Bu", "Lb")){
  print(BA)
  
  if(!file.exists(sprintf("data/002_modelling/aoa/%s_%s_SentinelLidar_aoa.tif", i, BA))){
    
    mask=terra::rast(sprintf("data/002_modelling/prediction/7TS_SentinelLidar_pred.tif",BA))
    
    mod=readRDS(sprintf("data/002_modelling/models/%s_SentinelLidar.RDS", BA))
    predictors2=terra::subset(predictors, mod$selectedvars)
    predictors2=terra::mask(predictors2, mask)
    rm(predictors)
    aoa=CAST::aoa(newdata=predictors2, model=mod, trainDI = readRDS(sprintf("data/002_modelling/trainDI/%s_SentinelLidar_trainDI.RDS", BA)))
    
    
    # save files
    saveRDS(aoa, sprintf("data/002_modelling/aoa/7TS_%s_SentinelLidar_aoa.RDS",  BA))
    terra::writeRaster(aoa, sprintf("data/002_modelling/aoa/7TS_%s_SentinelLidar_aoa.tif",  BA))
    rm(mod,predBa,predictors2,pred2)    
  }
}



